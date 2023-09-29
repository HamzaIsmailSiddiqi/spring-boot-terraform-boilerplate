resource "aws_cognito_user_pool_domain" "beta_user_pool_domain" {
  domain       = var.cognito_domain
  user_pool_id = aws_cognito_user_pool.beta_user_pool.id
}
