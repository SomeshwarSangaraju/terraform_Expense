variable "project"{
    default = "roboshop"
}

variable "environment"{
    default= "dev"
}

variable "instances"{
    default={
        mysql = "t3.micro"
        backend = "t3.micro"
        frontend = "t3.micro"
    }
}

variable "zone_id"{
    default = "Z01510281GETZQBO4NWF0"
}

variable "domain_name"{
    default = "someshwar.fun"
}