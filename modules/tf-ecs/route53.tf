resource "aws_route53_record" "www-live" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "jay.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.main.dns_name]
}

data "aws_route53_zone" "selected" {
  name         = "niiadu.com"
  private_zone = false
}