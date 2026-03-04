resource "aws_instance" "main" {
  for_each = var.instances
  ami           = local.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.this.id]
  tags = merge(
    local.tags,
    {
        Name = "${each.key}"
        Terraform = "true"
    }
  ) 
}

resource "aws_security_group" "this" {

  name   = "${var.project}-${var.environment}-allow_all"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}


