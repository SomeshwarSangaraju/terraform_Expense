locals{
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
    common_tags={
        Project = "Expense"
        Environment = "dev"
        Terraform = "true"
    }
    common_suffix_name = "${var.project}-${var.environment}"
}