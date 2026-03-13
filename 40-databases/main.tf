resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"   
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id =   local.database_subnet_ids
  iam_instance_profile = aws_iam_instance_profile.mysql.name
  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_suffix_name}-mysql"
    }
  )
}

resource "aws_iam_instance_profile" "mysql" {
  name = "mysql"
  role = "EC2SSMPARAMETERREAD"
}

resource "terraform_data" "mysql" {

   triggers_replace = [
    aws_instance.mysql.id
  ]
  
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.private_ip
  }

  # terraform copies this file to mongodb server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh mysql dev"
    ]
  }
}

