resource "aws_instance" "backend" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id = local.private_subnet_id

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_suffix_name}-backend"
    }
  )
}

# connect to instance using remote-exec provisioners through terraform data
resource "terraform_data" "backend" {
  triggers_replace = [
    aws_instance.backend.id
  ]

  # terraform copies this file to mongodb server
  provisioner "file" {
    source = "backend.sh"
    destination = "/tmp/backend.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.backend.private_ip
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/backend.sh",
        "sudo sh /tmp/backend.sh backend ${var.environment}"
    ]
  }
}

# stop the instance to take ami
resource "aws_ec2_instance_state" "backend" {
  instance_id = aws_instance.backend.id
  state       = "stopped"
  depends_on = [terraform_data.backend]

}

resource "aws_ami_from_instance" "backend" {
  name               = "${local.common_suffix_name}-backend-ami"
  source_instance_id = aws_instance.backend.id
  depends_on = [aws_ec2_instance_state.backend]
  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_suffix_name}-backend-ami"
    }
  )
}



# instance target group 
resource "aws_lb_target_group" "backend" {
  name     = "${local.common_suffix_name}-backend"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60 # waiting period before deleting the instance

  health_check {
    healthy_threshold = 2
    interval = 10
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 2
    unhealthy_threshold = 2
  }
}


resource "aws_launch_template" "backend" {
  name = "${local.common_suffix_name}-backend"
  image_id = aws_ami_from_instance.backend.id

  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"

  vpc_security_group_ids = [local.backend_sg_id]

  # when we run terraform apply again, a new version will be created with new AMI ID
  update_default_version = true

  # tags attached to the instance
  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.common_suffix_name}-backend"
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

resource "aws_autoscaling_group" "backend" {
  name                      = "${local.common_suffix_name}-backend"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false
  launch_template {
    id      = aws_launch_template.backend.id
    version = aws_launch_template.backend.latest_version
  }
  vpc_zone_identifier       = local.private_subnet_ids
  target_group_arns = [aws_lb_target_group.backend.arn]

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
        Name = "${local.common_suffix_name}-backend"
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


resource "aws_autoscaling_policy" "backend" {
  autoscaling_group_name = aws_autoscaling_group.backend.name
  name                   = "${local.common_suffix_name}-backend"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    host_header {
      values = ["backend.backend-alb-${var.environment}.${var.domain_name}"]
    }
  }
}

resource "terraform_data" "backend_local" {
  triggers_replace = [
    aws_instance.backend.id
  ]
  
  depends_on = [aws_autoscaling_policy.backend]
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.backend.id}"
  }
}

