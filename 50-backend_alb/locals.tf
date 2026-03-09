locals{

    backend_alb_sg_id = data.aws_ssm_parameter.backend_alb.arn
    private_subnet_ids= split("," , data.aws_ssm_parameter.private_subnet_ids.value)
    public_subnet_ids= split("," , data.aws_ssm_parameter.public_subnet_ids.value)
    database_subnet_ids= split("," , data.aws_ssm_parameter.database_subnet_ids.value)

    tags = {
        Project = "Roboshop"
        Environment = "dev"
        Terraform  = "true"
    }
    common_suffix_name = "${var.project}-${var.environment}"
}