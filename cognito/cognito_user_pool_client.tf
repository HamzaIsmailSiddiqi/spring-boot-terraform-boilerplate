resource "aws_cognito_user_pool_client" "beta_user_pool_client" {
  name                 = "beta-user-pool-client"
  user_pool_id         = aws_cognito_user_pool.beta_user_pool.id
  generate_secret      = false
  allowed_oauth_flows  = ["code"]
  allowed_oauth_scopes = ["email", "openid", "phone"]
  callback_urls        = var.callback_urls

  # Set the explicit_auth_flows to allow ALLOW_ADMIN_USER_PASSWORD_AUTH
  explicit_auth_flows = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]

  # Set the access token and ID token validity to 480 minutes (8 hours)
  access_token_validity         = 8 # Convert minutes to seconds
  id_token_validity             = 1 # Convert minutes to seconds
  prevent_user_existence_errors = "LEGACY"
  enable_token_revocation       = true
  supported_identity_providers  = ["COGNITO"]
}
