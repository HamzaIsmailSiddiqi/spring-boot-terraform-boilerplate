module "cognito" {
  source = "./cognito"
  cognito_domain = "beta-ecs-domain"
  user_pool      = "user-pool-beta"
  callback_urls  = ["https://app.${var.account_domain_name}/"]
  environment    = var.environment
  domain_name    = "no-reply@${module.aws_ses.ses_domain_identity_name}"
  domain_arn     = module.aws_ses.ses_domain_identity_arn
}
