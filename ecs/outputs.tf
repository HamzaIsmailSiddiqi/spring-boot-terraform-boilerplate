output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "service_discovery_namespace" {
  value = aws_service_discovery_private_dns_namespace.ecs.arn
}

output "namespace" {
  value = aws_service_discovery_private_dns_namespace.ecs.name
}
