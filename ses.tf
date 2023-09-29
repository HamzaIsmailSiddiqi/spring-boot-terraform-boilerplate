# Add Amazon SES as needed for Cognito
# Domain name is: e.beta.technetium.io
# Email should be sent from no-reply@e.beta.technetium.io
module "aws_ses" {
  source = "git::git@gitlab.dev.technetium.io:technetium/terraform-modules/aws-ses.git"

  domain_name       = "e.${var.account_domain_name}"
  zone_id           = module.baseline.public_hosted_zone_id
  mail_from_enabled = true
  spf_enabled       = true
  verify_dkim       = true
}
