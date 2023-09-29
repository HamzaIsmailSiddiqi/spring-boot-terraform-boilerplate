module "public-api-nlb" {
  source                       = "./public_api_nlb"
  name                         = var.name
  vpc_id                       = module.baseline.vpc_id
  subnets                      = module.baseline.private_subnets
  environment                  = var.environment
  nlb_security_groups          = [module.security_groups.public_api_nlb_sg]
  alb_tls_cert_arn             = module.baseline.wildcard_certificate_arn
  health_check_path            = var.management_healthcheck_path
  idle_timeout_seconds         = var.alb_idle_timeout_seconds
  domain_name                  = module.public-api-nlb.aws_nlb_dns_name
  private_hosted_zone_id       = module.baseline.private_hosted_zone_id
  public_api_app_port          = var.spring_boot_app_port
  public_api_health_check_port = var.spring_boot_management_port
}

module "public-api-gateway" {
  source                  = "./public_api_gateway"
  api_gateway_name        = "public-api-gateway"
  vpc_link_name           = "public-api-vpc-link"
  domain_name             = var.account_domain_name
  public_api_tls_cert_arn = module.baseline.wildcard_certificate_arn
  private_hosted_zone_id  = module.baseline.private_hosted_zone_id
  public_hosted_zone_id   = module.baseline.public_hosted_zone_id
  vpc_link_target_arn     = module.public-api-nlb.aws_nlb_arn
  dns_name                = module.public-api-nlb.aws_nlb_dns_name
  app_port                = var.spring_boot_app_port
  stage                   = var.environment
  environment             = var.environment
  region                  = var.aws_region
  user_pool_id            = module.cognito.cognito_user_pool_id
  user_pool_arn           = module.cognito.cognito_user_pool_arn
}

module "public-api-cognito" {
  source                = "./public_api/cognito"
  certificate_arn       = var.cognito_certificate_arn
  domain_name           = var.account_domain_name
  public_hosted_zone_id = module.baseline.public_hosted_zone_id
  user_pool_id          = module.cognito.cognito_user_pool_id
}
