variable "certificate_arn" {
  description = "The ARN of the certificate to use with the cognito custom domain."
}

variable "user_pool_id" {
  description = "The ID of the Beta User Pool ID."
}

variable "domain_name" {
  description = "The root domain name of the account."
}

variable "public_hosted_zone_id" {
  description = "The public hosted zone where the auth alias A record will be created."
}
