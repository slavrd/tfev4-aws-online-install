data "aws_route53_zone" "r53zone" {
  name = var.hosted_zone_name
}

resource "aws_route53_record" "tfe" {
  zone_id = data.aws_route53_zone.r53zone.id
  name    = var.cname_record
  type    = "CNAME"
  ttl     = "60"
  records = [var.cname_value]
}
