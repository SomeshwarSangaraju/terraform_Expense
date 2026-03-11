locals{
    vpc_cidr = var.vpc_cidr
    public_subnet_ids = var.public_subnet_cidrs
    private_subnet_ids = var.private_subnet_cidrs
    database_subnet_ids = var.database_subnet_cidrs

    az_names = slice(data.aws_availability_zones.available_zones.names, 0, 2)

    vpc_tags={
        Project = "expense"
        Environment = "dev"
    }
    common_suffix_name = "${var.project}-${var.environment}"
}