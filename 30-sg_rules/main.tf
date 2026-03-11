resource "aws_security_group_rule" "laptop_bastion" {
  type              = "ingress"
  security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}


