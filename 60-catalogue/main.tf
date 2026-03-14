resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  subnet_id = local.private_subnet_id

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_suffix_name}-catalogue"
    }
  )
}

resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]


  # terraform copies this file to mongodb server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh mysql dev"
    ]
  }
}

