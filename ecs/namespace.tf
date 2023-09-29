resource "aws_service_discovery_private_dns_namespace" "ecs" {
  vpc         = var.vpc_id
  name        = var.ecs_connect_namespace
  description = "ecs service connect service discovery"
}
