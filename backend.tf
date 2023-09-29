resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name           = "us-east-2-249069628117-terraform-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-249069628117"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "us-east-2-249069628117-terraform-state-lock"
    role_arn       = "arn:aws:iam::249069628117:role/AdministratorAccess"
    session_name   = "terraform"
  }
}
