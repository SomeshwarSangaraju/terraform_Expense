locals{
    common_suffix_name = "${var.project}-${var.environment}"
    ami_id = data.aws_ami.joindevops.id
    frontend_sg_id = data.aws_ssm_parameter.frontend_sg_id.value
    private_subnet_ids = split("," , data.aws_ssm_parameter.private_subnet_ids.value)[0]
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    frontend_alb_listener_arn = data.aws_ssm_parameter.frontend_alb_listener_arn.value
    common_tags = {
        Project = "Roboshop"
        Environment = "dev"
        Terraform  = "true"
    }
}