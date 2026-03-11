variable "vpc_cidr"{
    default = "10.0.0.0/16"
}

variable "vpc_tags"{
    default = {}
    type = map
}

variable "project"{
    default = "expense"
}

variable "environment"{
    default = "dev"
}

variable "public_subnet_cidrs"{
    default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "private_subnet_cidrs"{
    default = ["10.0.11.0/24","10.0.12.0/24"]
}
variable "database_subnet_cidrs"{
    default = ["10.0.21.0/24","10.0.22.0/24"]
}

variable "availability_zone"{
    default = ["us-east-1a", "us-east-1b"]
}

