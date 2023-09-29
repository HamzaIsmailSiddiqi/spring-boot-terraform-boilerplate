output "alb_sg" {
  value = aws_security_group.alb.id
}
output "public_api_nlb_sg" {
  value = aws_security_group.public_api_nlb_sg.id
}
output "public_api_ecs_service_sg_id" {
  value = aws_security_group.public_api_ecs_service_sg.id
}
output "application_ecs_service_sg_id" {
  value = aws_security_group.application_ecs_service_sg.id
}
output "admin_ecs_service_sg_id" {
  value = aws_security_group.admin_ecs_service_sg.id
}
output "client_ecs_service_sg_id" {
  value = aws_security_group.client_ecs_service_sg.id
}
output "subscription_ecs_service_sg_id" {
  value = aws_security_group.subscription_ecs_service_sg.id
}
output "configuration_ecs_service_sg_id" {
  value = aws_security_group.configuration_ecs_service_sg.id
}
output "user_ecs_service_sg_id" {
  value = aws_security_group.user_ecs_service_sg.id
}
output "ui_ecs_service_sg_id" {
  value = aws_security_group.ui_ecs_service_sg.id
}
output "technetium_ecs_service_sg_id" {
  value = aws_security_group.technetium_ecs_service_sg.id
}
output "identity_ecs_service_sg_id" {
  value = aws_security_group.identity_ecs_service_sg.id
}
output "prometheus_ecs_service_sg_id" {
  value = aws_security_group.prometheus_ecs_service_sg.id
}
output "ingress_gateway_ecs_service_sg_id" {
  value = aws_security_group.ingress_gateway_ecs_service_sg.id
}
