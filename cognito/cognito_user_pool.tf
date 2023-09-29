resource "aws_cognito_user_pool" "beta_user_pool" {
  name = var.user_pool

  # Optional settings
  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  email_configuration {
    email_sending_account = "DEVELOPER"
    from_email_address    = var.domain_name
    source_arn            = var.domain_arn
  }

  schema {
    name                = "email"
    required            = true
    attribute_data_type = "String"

    string_attribute_constraints {
      min_length = 1
      max_length = 254
    }
  }

  username_configuration {
    case_sensitive = true
  }

  alias_attributes = ["preferred_username", "email"]

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  tags = {
    Name        = var.user_pool
    Environment = var.environment
  }
}
