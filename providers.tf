provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::249069628117:role/AdministratorAccess"
  }
}
