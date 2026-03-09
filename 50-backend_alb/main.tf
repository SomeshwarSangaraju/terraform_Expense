resource "aws_lb" "backend_alb" {
  name               = "${local.common_suffix_name}-backend_alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend_alb_sg_id]
  subnets            = [local.public_subnet_ids]

  enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Name = "${local.common_suffix_name}-backend_alb"
  }
}

