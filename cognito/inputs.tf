variable "user_pool" {
  description = "the name of your AWS Cognito User Pool, e.g. \"cognito-test\""
}

variable "cognito_domain" {
  description = "The name of the Cognito domain to be created."
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "callback_urls" {
  description = "The valid callback urls."
  type        = list(string)
}

variable "domain_name" {
  description = "the name of the email of the sender"
}

variable "domain_arn" {
  description = "the arn of the email of the sender"
}
