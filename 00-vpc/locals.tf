locals{
    vpc_cidr = var.vpc_cidr
    public_subnet_cidrs = var.public_subnet_cidrs
    az_names = slice(data.aws_availability_zones.available_zones.names, 0, 2)

    vpc_tags={
        Project = "roboshop"
        Environment = "dev"
    }
    common_suffix_name = "${var.project}-${var.environment}"
}