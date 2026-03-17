resource "aws_instance" "frontend" {
  ami           = local.ami_id
  instance_type = "t3.micro"

  vpc_security_group_ids = [local.frontend_sg_id]
  subnet_id = local.private_subnet_id

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_suffix_name}-frontend"
    }
  )
}

resource "terraform_data" "frontend" {
  triggers_replace = [
   aws_instance.frontend.id
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user" # Or "ubuntu", etc., depending on the AMI
    password    = "DevOps321"
    host        = aws_instance.frontend.private_ip
  }
  provisioner "file" {
    source      = "frontend.sh"         # Local path
    destination = "/tmp/frontend.sh"    # Remote path
  }

  provisioner "remote-exec" {
    inline=[
        "chmod +x /tmp/frontend.sh",
        "sudo sh /tmp/frontend.sh frontend ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "frontend" {
  instance_id = aws_instance.frontend.id
  state       = "stopped"
  depends_on = [terraform_data.frontend]
}

resource "aws_ami_from_instance" "frontend" {
  name               = "${local.common_suffix_name}-frontend-ami"
  source_instance_id = aws_instance.frontend.id
  description        = "AMI created by Terraform from an existing instance"
  depends_on = [aws_ec2_instance_state.frontend]
  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_suffix_name}-frontend-ami"
    }
  )
}

resource "aws_lb_target_group" "frontend" {
  name        = "${local.common_suffix_name}-frontend"
  port        = 80
  protocol    = "HTTP"
  # target_type = "ip"
  vpc_id      = local.vpc_id
  deregistration_delay = 60 # waiting period before deleting the instance

  health_check{
    healthy_threshold = 2
    interval = 10
    protocol = "HTTP"
    matcher = "200-299"
    path = "/"
    port = 80
    unhealthy_threshold = 2
    timeout = 2
  }
}


resource "aws_launch_template" "frontend" {
  name = "${local.common_suffix_name}-frontend"
  image_id = aws_ami_from_instance.frontend.id

  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.frontend_sg_id]

   # when we run terraform apply again, a new version will be created with new AMI ID
  update_default_version = true

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
          Name = "${local.common_suffix_name}-frontend"
      }
    )
  }

  # tags attached to the volume created by instance
  tag_specifications {
    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.common_suffix_name}-backend"
      }
    )
  }

  # tags attached to the launch template
  tags = merge(
      local.common_tags,
      {
        Name = "${local.common_suffix_name}-backend"
      }
  )
}

resource "aws_autoscaling_group" "frontend" {
  name                      = "${local.common_suffix_name}-frontend"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false
  launch_template {
    id      = aws_launch_template.frontend.id
    version = aws_launch_template.frontend.latest_version
  }
  vpc_zone_identifier       = [local.private_subnet_id]
  target_group_arns = [aws_lb_target_group.frontend.arn]


 instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50 # atleast 50% of the instances should be up and running
    }
    triggers = ["launch_template"]
  }
  
  dynamic "tag" {  # we will get the iterator with name as tag
    for_each = merge(
      local.common_tags,
      {
        Name = "${local.common_suffix_name}-frontend"
      }
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  timeouts {
    delete = "15m"
  }
}

resource "aws_autoscaling_policy" "frontend" {
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  name                   = "${local.common_suffix_name}-frontend"
  policy_type            = "TargetTrackingScaling"
  
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = local.frontend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["${var.project}-${var.environment}.${var.domain_name}"] 
    }
  }
}


resource "terraform_data" "frontend_local" {
  triggers_replace = [
    aws_instance.frontend.id
  ]
  
  depends_on = [aws_autoscaling_policy.frontend]
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.frontend.id}"
  }
}
