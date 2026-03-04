resource "aws_route53_record" "roboshop" {
  for_each = var.instances 
  zone_id = var.zone_id
  name    = "${var.instances[each.value]}"
  type    = "A"
  ttl     = 1
  records = ["${var.instances[each.value] == "frontend" ? "${var.domain_name}" : "${var.instances[each.value]}.${var.domain_name}"} "]
}