# resource "aws_instance" "bastion" {
#   ami           = local.ami_id
#   instance_type = "t3.micro"
#   vpc_security_group_ids = [local.bastion_sg_id]
#   subnet_id = local.public_subnet_ids

#   tags = {
#     Name = "${local.common_suffix_name}-bastion"
#   }
# }

resource "aws_instance" "bastion" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.public_subnet_ids
  vpc_security_group_ids = [local.bastion_sg_id]

  tags = {
    Name = "${local.common_suffix_name}-bastion"
  }
}