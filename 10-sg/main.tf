resource "aws_security_group" "allow_all" {
  count = length(var.sg_names)
  name        = "${local.common_suffix_name}-${var.sg_names[count.index]}"
  description = "creating security group through terraform"
  vpc_id      = local.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge (
    local.sg_tags,
    {
      Name = "${local.common_suffix_name}-${var.sg_names[count.index]}"
    }
  )
}


