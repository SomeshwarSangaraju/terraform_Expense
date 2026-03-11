variable "project"{
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "sg_names"{
    default = [
        #database
        "mongodb", "redis", "mysql", "rabbitmq",
        # backend
        "catalogue", "user", "cart", "shipping", "payment",
        #frontend
        "frontend",
        "bastion", "fronend_alb", "backend_alb"
    ]
}