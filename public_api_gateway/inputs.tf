variable "environment" {
  description = "The name of your environment, e.g. \"prod\""
}

variable "region" {
  description = "The AWS region in which resources are created"
}

variable "log_retention_days" {
  default = 30
}

variable "dns_name" {
  description = "Public api nlb dns name"
}

variable "app_port" {
  description = "Application port"
}

variable "vpc_link_name" {
  description = "The name of your stack, e.g. \"demo\""
}

variable "api_gateway_name" {
  description = "The name of your stack, e.g. \"demo\""
}

variable "vpc_link_target_arn" {
  description = "Arn of public api nlb"
}

variable "private_hosted_zone_id" {
  description = "The private route53 hosted zone"
}

variable "public_hosted_zone_id" {
  description = "The public route53 hosted zone"
}

variable "domain_name" {
  description = "The public hosted zone domain name"
}

variable "public_api_tls_cert_arn" {
  description = "The ARN of the certificate that the Api gateway uses for https"
}

variable "stage" {
  description = "Deployment stage of public api gateway"
}

variable "user_pool_id" {
  description = "Cognito user pool id for public api gateway authorizer"
}

variable "user_pool_arn" {
  description = "Cognito user pool arn for public api gateway authorizer"
}
