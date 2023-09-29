resource "aws_acm_certificate" "wildcard_certificate" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name = "wildcard_certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "beta_wildcard_record" {
  count = length(aws_acm_certificate.wildcard_certificate.domain_validation_options)

  allow_overwrite = true
  zone_id         = aws_route53_zone.public_zone.id
  name            = element(aws_acm_certificate.wildcard_certificate.domain_validation_options.*.resource_record_name, count.index)
  type            = element(aws_acm_certificate.wildcard_certificate.domain_validation_options.*.resource_record_type, count.index)
  records         = [element(aws_acm_certificate.wildcard_certificate.domain_validation_options.*.resource_record_value, count.index)]
  ttl             = 60
}

resource "aws_acm_certificate_validation" "wildcard_certificate_validation" {
  certificate_arn         = aws_acm_certificate.wildcard_certificate.arn
  validation_record_fqdns = aws_route53_record.beta_wildcard_record.*.fqdn
}
