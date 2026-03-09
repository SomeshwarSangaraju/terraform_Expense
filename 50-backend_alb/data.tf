data "aws_ssm_parameter" "backend_alb"{
    name = "/${var.project}/${var.environment}/backend_alb_sg_id" 
}
data "aws_ssm_parameter" "public_subnet_ids"{
    name = "/${var.project}/${var.environment}/public_subnet_ids" 
}