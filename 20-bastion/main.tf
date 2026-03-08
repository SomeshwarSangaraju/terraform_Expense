resource "aws_instance" "main" {
  for_each = var.instances
  ami           = local.ami
  instance_type = each.value
  vpc_security_group_ids = [aws_security_group.this.id]

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip} > inventory"
  }

    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
        "sudo dnf install nginx -y",
        "sudo systemctl start nginx"
        ]
    }

    provisioner "remote-exec" {
      inline = [
        "sudo systemctl stop nginx",
        "echo 'successfully stopped nginx server' "
      ]
      when = destroy
    }
  

  tags = merge(
    local.tags,
    {
        Name = each.key
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


