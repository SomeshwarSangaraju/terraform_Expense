resource "aws_ssm_parameter" "vpc" {
  name  = "/${var.project}/${var.environment}/vpc_id"
  type  = "String"
  value = aws_vpc.main.id
}

# resource "aws_ssm_parameter" "public_subnet_ids" {
#   name  = "/${var.project}/${var.environment}/public_subnet_ids"
#   type  = "StringList"
#   value = join("," ,local.public_subnet_ids)
# }

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project}/${var.environment}/public_subnet_ids"
  type  = "StringList"
  value = join(",", local.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join("," , local.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.project}/${var.environment}/database_subnet_ids"
  type  = "StringList"
  value = join("," , local.database_subnet_ids)
}

