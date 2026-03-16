locals{
    ami_id = data.aws_ami.joindevops.id
    backend_sg_id = data.aws_ssm_parameter.backend_sg_id.value
    private_subnet_id = split("," , data.aws_ssm_parameter.private_subnet_ids.value)[0]
    private_subnet_ids = split("," , data.aws_ssm_parameter.private_subnet_ids.value)
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    backend_alb_listener_arn = data.aws_ssm_parameter.backend_alb_listener_arn.value

    common_tags={
        Project = "Expense"
        Environment = "Dev"
        Terraform = "true"
    }
    common_suffix_name = "${var.project}-${var.environment}"
}

