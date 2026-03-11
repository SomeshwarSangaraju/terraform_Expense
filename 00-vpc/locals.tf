locals{
    vpc_cidr = var.vpc_cidr
    # public_subnet_ids = var.public_subnet_cidrs
    public_subnet_ids = aws_subnet.public[*].id

    private_subnet_ids = aws_subnet.private[*].id
    database_subnet_ids = aws_subnet.database[*].id

    az_names = slice(data.aws_availability_zones.available_zones.names, 0, 2)

    vpc_tags={
        Project = "expense"
        Environment = "dev"
    }
    common_suffix_name = "${var.project}-${var.environment}"
}