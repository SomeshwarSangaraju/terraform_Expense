resource "aws_vpc" "main" {
  cidr_block       = local.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = merge( 
    local.vpc_tags,
    {
        Name = local.common_suffix_name
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = merge( 
    local.vpc_tags,
    {
        Name = local.common_suffix_name
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]

  map_public_ip_on_launch = true
  availability_zone = local.az_names[count.index]

  tags = merge( 
    local.vpc_tags,
    {
        Name = "${local.common_suffix_name}-public"
    }
  )
}
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]

  map_public_ip_on_launch = true
  availability_zone = local.az_names[count.index]

  tags = merge( 
    local.vpc_tags,
    {
        Name = "${local.common_suffix_name}-private"
    }
  )
}
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]

  map_public_ip_on_launch = true
  availability_zone = local.az_names[count.index]

  tags = merge( 
    local.vpc_tags,
    {
        Name = "${local.common_suffix_name}-database"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.vpc_id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.example.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  }

  tags = {
    Name = "example"
  }
}


resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.foo.id
  route_table_id = aws_route_table.bar.id
}


