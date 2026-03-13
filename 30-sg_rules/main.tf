resource "aws_security_group_rule" "laptop_bastion" {
  type              = "ingress"
  security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}
 
resource "aws_security_group_rule" "public_frontend_alb" {
  type              = "ingress"
  security_group_id = local.frontend_alb_sg_id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion_mysql" {
  type              = "ingress"
  security_group_id = local.mysql_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "bastion_backend" {
  type              = "ingress"
  security_group_id = local.backend_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "bastion_frontend" {
  type              = "ingress"
  security_group_id = local.frontend_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "backend_alb_backend" {
  type              = "ingress"
  security_group_id = local.backend_sg_id
  source_security_group_id = local.backend_alb_sg_id
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
}

resource "aws_security_group_rule" "backend_mysql" {
  type              = "ingress"
  security_group_id = local.mysql_sg_id
  source_security_group_id = local.backend_sg_id
  from_port         = 3306
  protocol          = "tcp"
  to_port           = 3306
}

resource "aws_security_group_rule" "frontend_backend_alb" {
  type              = "ingress"
  security_group_id = local.frontend_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
}
