resource "aws_route53_record" "Route53" {
  count = "${var.domain-name != "" ? 1 : 0}"

  depends_on = ["aws_lb.alb", "aws_cloudfront_distribution.cdn"]

  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.domain-name}"
  type    = "A"

alias = {

    name                   = "${var.use_cloudfront == "true" ? element(concat(aws_cloudfront_distribution.cdn.*.domain_name, list("")), 0) : aws_lb.alb.dns_name}"
    zone_id                = "${var.use_cloudfront == "true" ? element(concat(aws_cloudfront_distribution.cdn.*.hosted_zone_id, list("")), 0) : aws_lb.alb.zone_id}"
    evaluate_target_health = true
  }
} 

resource "aws_route53_record" "internal-dns" {
  count = "${var.use_cloudfront != "false" ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.internal-domain-name}"
  type    = "A"

  depends_on = ["aws_lb.alb"]

  weighted_routing_policy = {
    weight = "${var.internal-domain-weight}"
  }

  set_identifier = "old_env"

  alias = {
    name = "${aws_lb.alb.dns_name}"
    zone_id = "${aws_lb.alb.zone_id}"
    evaluate_target_health = false
  }
}
