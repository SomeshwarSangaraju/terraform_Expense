data "aws_ssm_parameter" "bastion_sg_id"{
    name = "/${var.project}/${var.environment}/bastion_sg_id"
}