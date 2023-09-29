output "cognito_user_pool_arn" {
  value = aws_cognito_user_pool.beta_user_pool.arn
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.beta_user_pool.id
}
