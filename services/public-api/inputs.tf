variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "region" {
  description = "the AWS region in which resources are created"
}

variable "account" {
  description = "The AWS Account for this deployment"
}

variable "subnets" {
  description = "List of subnet IDs"
}

variable "ecs_service_security_groups" {
  description = "Comma separated list of security groups"
}

variable "deployment_minimum_healthy_percent" {}
variable "deployment_max_running_tasks_percent" {}

variable "container_port" {
  description = "Port of container"
}

variable "prometheus_port" {
  description = "Port of prometheus"
}

variable "prometheus_path" {
  description = "Path for prometheus metrics"
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
}

variable "ecr_repository" {
  description = "The ECR Repository to fetch the container images from"
}

variable "ecr_repository_arn" {
  description = "The ARN of the ECR Repository to pull the container images from"
}

variable "ecr_image_version" {
  description = "The tag to pull from the ECR repository"
}

variable "aws_nlb_target_group_arn" {
  description = "ARN of the nlb target group"
}

variable "service_desired_count" {
  description = "Number of services running in parallel"
}

variable "container_environment" {
  description = "The container environmnent variables"
  type        = list(any)
}

variable "ecs_cluster_id" {}
variable "namespace" {}
variable "ecs_connect_namespace" {}
variable "log_retention" {}
