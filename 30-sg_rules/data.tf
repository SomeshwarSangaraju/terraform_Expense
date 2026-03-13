data "aws_ssm_parameter" "bastion_sg_id"{
    name = "/${var.project}/${var.environment}/bastion_sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id"{
    name = "/${var.project}/${var.environment}/mysql_sg_id"
}

data "aws_ssm_parameter" "backend_sg_id"{
    name = "/${var.project}/${var.environment}/backend_sg_id"
}

data "aws_ssm_parameter" "frontend_sg_id"{
    name = "/${var.project}/${var.environment}/frontend_sg_id"
}

data "aws_ssm_parameter" "frontend_alb_sg_id"{
    name = "/${var.project}/${var.environment}/frontend_alb_sg_id"
}

data "aws_ssm_parameter" "backend_alb_sg_id"{
    name = "/${var.project}/${var.environment}/backend_alb_sg_id"
}

