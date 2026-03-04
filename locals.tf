locals{
    ami= data.aws_ami.ami.id
    tags={
        Name = "${var.project}-${var.environment}"
    }
}