variable "project"{
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "sg_names"{
    default = [
        #database
        "mysql",
        # backend
        "backend",
        #frontend
        "frontend",
        #loadbalancer
        "bastion", "frontend_alb", "backend_alb"
    ]
}