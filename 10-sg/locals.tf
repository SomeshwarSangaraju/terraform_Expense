locals{
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_tags={
        Project = "Roboshop"
        Environment = "Dev"
    }
    common_suffix_name = "${var.project}-${var.environment}"
}