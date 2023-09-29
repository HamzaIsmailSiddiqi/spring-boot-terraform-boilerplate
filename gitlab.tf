module "gitlab" {
  source = "./gitlab_ecs_deployment"

  dev_iam_role_arn = var.dev_gitlab_runner_iam_role_arn
  region           = var.aws_region
  account          = var.aws_account_id
}
