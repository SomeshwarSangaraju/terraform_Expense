locals{
    common_suffix_name = "${var.project}-${var.environment}"
    frontend_alb_sg_id = data.aws_ssm_parameter.frontend_alb_sg_id.value
    public_subnet_ids= split("," , data.aws_ssm_parameter.public_subnet_ids.value)
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = {
        Project = "Roboshop"
        Environment = "dev"
        Terraform  = "true"
    }
    frontend_alb_certificate_arn = data.aws_ssm_parameter.frontend_alb_certificate_arn.value
}
