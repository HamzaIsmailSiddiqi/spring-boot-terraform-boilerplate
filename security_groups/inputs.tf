variable "name" {
  description = "the name of your stack, e.g. \"beta\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"beta\""
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
}

variable "default_http_port" {
  description = "The default port for HTTP traffic"
}

variable "prometheus_port" {
  description = "The port used for prometheus ingress"
}

variable "spring_boot_app_port" {
  description = "The port exposed for app traffic to the ingress gateway microservice"
}

variable "spring_boot_management_port" {
  description = "The port exposed for actuator traffic to the ingress gateway microservice"
}
