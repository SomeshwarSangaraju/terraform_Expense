
resource "aws_ssm_parameter" "sg_id" {
  count = length(var.sg_names)
  name  = "/${var.project}/${var.environment}/${var.sg_names[count.index]}_sg_id" # /expense/dev/catalogue_sg_id
  type  = "String"
  # value = module.sg[count.index].sg_id
  # value = var.sg_names[count.index].sg_id
  value = aws_security_group.allow_all[count.index].id
  overwrite = true
}
