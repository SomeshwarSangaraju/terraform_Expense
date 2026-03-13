data "aws_ami" "joindevops" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["973714476881"] 
}

data "aws_ssm_parameter" "database_subnet_ids"{
    name = "/${var.project}/${var.environment}/database_subnet_ids"
}

data "aws_ssm_parameter" "mysql_sg_id"{
    name = "/${var.project}/${var.environment}/mysql_sg_id"
}

