resource "aws_cognito_user_pool_domain" "cognito_user_pool_domain" {
  domain          = "auth.${var.domain_name}"
  certificate_arn = var.certificate_arn
  user_pool_id    = var.user_pool_id
}

resource "aws_route53_record" "route53_record" {
  name    = aws_cognito_user_pool_domain.cognito_user_pool_domain.domain
  type    = "A"
  zone_id = var.public_hosted_zone_id

  alias {
    evaluate_target_health = false

    name    = aws_cognito_user_pool_domain.cognito_user_pool_domain.cloudfront_distribution
    zone_id = aws_cognito_user_pool_domain.cognito_user_pool_domain.cloudfront_distribution_zone_id
  }
}
