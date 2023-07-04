resource "aws_route53_zone" "primary" {
  name = "ram.eee"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.ram.eee"
  type    = "A"
  ttl     = 300
  records = [aws_instance.Krishna.public_ip]
}
