variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "aws_account_id" {
  type    = string
  default = "249069628117"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.3.0/24", "10.10.4.0/24"]
}

variable "account_domain_name" {
  type    = string
  default = "beta.technetium.io"
}

variable "name" {
  type    = string
  default = "ecs"
}

variable "environment" {
  type    = string
  default = "beta"

}

variable "default_http_port" {
  default = 80
}

variable "ui_container_port" {
  default = 80
}

variable "alb_security_groups" {
  description = "Comma separated list of security groups"
  default     = ""
}

variable "alb_tls_cert_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
  default     = "arn:aws:acm:us-east-2:249069628117:certificate/881d9052-e0b8-4ccf-9e18-2035cd40b7ec"
}

variable "alb_idle_timeout_seconds" {
  description = "This sucks, but we need to increase the default from 60 to 4 minutes for DataTree issues"
  default     = 300
}

variable "deployment_minimum_healthy_percent" {
  default = 100
}

variable "deployment_max_running_tasks_percent" {
  default = 200
}

variable "health_check_path" {
  description = "Path to check if the service is healthy, e.g. \"/status\""
  default     = "/"
}

variable "cluster_name" {
  default = "ecs-cluster-beta"
}

variable "ecs_task_execution_role" {
  default = ""
}

variable "spring_boot_app_port" {
  default = 8080
}
variable "spring_boot_management_port" {
  default = 8081
}
variable "spring_boot_prometheus_path" {
  default = "/actuator/prometheus"
}

variable "configuration_path" {
  type    = list(string)
  default = ["/api/configuration", "/api/configuration/*"]
}

variable "ecs_connect_namespace" {
  default = "technetium"
}

variable "management_healthcheck_path" {
  default = "/actuator/health"
}

variable "vpc_id" {
  default = "vpc-02f80714193e07d29"
}

variable "technetium_desired_count" {
  default = 1
}
variable "technetium_ecr_repository" {
  default = "959459629562.dkr.ecr.us-east-2.amazonaws.com/lender"
}
variable "technetium_ecr_repository_arn" {
  default = "arn:aws:ecr:us-east-2:959459629562:repository/lender"
}
variable "technetium_image_version" {
  default = "ef40ce4e"
}
variable "s3_bucket_name" {
  default = "ps-files-storage-beta"
}

variable "log_retention_days" {
  default = 30
}

variable "dev_gitlab_runner_iam_role_arn" {
  default = "arn:aws:iam::959459629571:role/GitLabRunnerRole"
}

variable "public_api_container_cpu" {
  default = 1024
}
variable "public_api_container_memory" {
  default = 2048
}
variable "public_api_desired_count" {
  description = "Number of public api tasks"
  default     = 1
}
variable "public_api_ecr_repository" {
  default = "959459629562.dkr.ecr.us-east-2.amazonaws.com/public-api"
}
variable "public_api_ecr_repository_arn" {
  default = "arn:aws:ecr:us-east-2:959459629571:repository/public-api"
}
variable "public_api_image_version" {
  default = "42fc9dfe"
}
variable "cognito_certificate_arn" {
  default = "arn:aws:acm:us-east-1:249069628117:certificate/48101f43-d566-43da-8999-616ba608fe33"
}
