locals{
    ami_id = data.aws_ami.joindevops.id
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
    public_subnet_ids = split(",",data.aws_ssm_parameter.public_subnet_ids.value)[0]
    common_tags={
        Project = "Expense"
        Environment = "dev"
        Terraform ="true"
    }
    common_suffix_name = "${var.project}-${var.environment}"
}