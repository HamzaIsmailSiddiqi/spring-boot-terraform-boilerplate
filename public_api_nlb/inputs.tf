variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "subnets" {
  description = "Comma separated list of subnet IDs"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "nlb_security_groups" {
  description = "Comma separated list of security groups"
}

variable "alb_tls_cert_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
}

variable "idle_timeout_seconds" {
  description = "The amount of time we wait for Idle http requests to complete."
}

variable "health_check_path" {
  description = "Path to check if the service is healthy, e.g. \"/status\""
}

variable "private_hosted_zone_id" {
  description = "The private route53 hosted zone"
}

variable "domain_name" {
  description = "The private hosted zone domain name"
}

variable "public_api_app_port" {
  description = "The application port for the public api"
}

variable "public_api_health_check_port" {
  description = "The management port for the public api health checks"
}
