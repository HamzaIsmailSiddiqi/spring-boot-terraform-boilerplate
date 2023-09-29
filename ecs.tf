locals {
  dotnet_environment_variables = [
    {
      name  = "ASPNETCORE_ENVIRONMENT",
      value = var.environment
    },
    {
      name  = "ASPNETCORE_URLS",
      value = "http://+:80;http://+:9090"
    }
  ]
}

module "ecs" {
  source = "./ecs"

  vpc                   = module.baseline.vpc
  cluster_name          = var.cluster_name
  ecs_connect_namespace = var.ecs_connect_namespace
  vpc_id                = var.vpc_id
}

module "security_groups" {
  source = "./security_groups"

  name                        = var.name
  environment                 = var.environment
  vpc_id                      = module.baseline.vpc_id
  vpc_cidr                    = var.vpc_cidr
  default_http_port           = var.default_http_port
  prometheus_port             = var.prometheus_container_port
  spring_boot_app_port        = var.spring_boot_app_port
  spring_boot_management_port = var.spring_boot_management_port
}

module "ecs-public-api-service" {
  source                               = "./services/public-api"
  name                                 = "public-api"
  ecs_cluster_id                       = module.ecs.ecs_cluster_id
  environment                          = var.environment
  region                               = var.aws_region
  account                              = var.aws_account_id
  aws_nlb_target_group_arn             = module.public-api-nlb.aws_nlb_tg_arn
  subnets                              = module.baseline.private_subnets
  ecs_service_security_groups          = [module.security_groups.public_api_ecs_service_sg_id]
  container_port                       = var.spring_boot_app_port
  deployment_minimum_healthy_percent   = var.deployment_minimum_healthy_percent
  deployment_max_running_tasks_percent = var.deployment_max_running_tasks_percent
  container_cpu                        = var.public_api_container_cpu
  container_memory                     = var.public_api_container_memory
  service_desired_count                = var.public_api_desired_count
  namespace                            = module.ecs.service_discovery_namespace
  ecs_connect_namespace                = var.ecs_connect_namespace
  ecr_repository                       = var.public_api_ecr_repository
  ecr_repository_arn                   = var.public_api_ecr_repository_arn
  ecr_image_version                    = var.public_api_image_version
  prometheus_port                      = var.spring_boot_management_port
  prometheus_path                      = var.spring_boot_prometheus_path
  log_retention                        = var.log_retention_days

  container_environment = [
    {
      name  = "SPRING_PROFILES_ACTIVE",
      value = var.environment
    }
  ]
}
