resource "aws_api_gateway_account" "public_api" {
  cloudwatch_role_arn = aws_iam_role.public_api_gateway_cloudwatch_role.arn
}

resource "aws_iam_role" "public_api_gateway_cloudwatch_role" {
  name = "ApiGatewayCloudwatchRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
        "sts:AssumeRole"],
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "public_api_gateway_cloudwatch_policy" {
  name        = "ApiGatewayCloudwatchPolicy"
  description = "Policy for API Gateway to write cloudWatch logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
        "logs:FilterLogEvents"],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_cloudwatch_policy_attachment" {
  policy_arn = aws_iam_policy.public_api_gateway_cloudwatch_policy.arn
  role       = aws_iam_role.public_api_gateway_cloudwatch_role.name
}

resource "aws_api_gateway_vpc_link" "public_api" {
  name = var.vpc_link_name
  target_arns = [
  var.vpc_link_target_arn]
}

data "template_file" "openapi_definition" {
  template = file("./public_api_gateway/openapi.yaml")
  vars = {
    uri          = "http://${var.dns_name}:${var.app_port}"
    connectionId = aws_api_gateway_vpc_link.public_api.id
    userPoolArn  = var.user_pool_arn
    readScope    = "https://api.${var.domain_name}/Read"
  }
  depends_on = [
  aws_api_gateway_vpc_link.public_api]
}

resource "aws_api_gateway_rest_api" "public_api" {
  name = var.api_gateway_name
  body = data.template_file.openapi_definition.rendered
  endpoint_configuration {
    types = [
    "REGIONAL"]
  }
  depends_on = [data.template_file.openapi_definition]
}


resource "aws_api_gateway_deployment" "public_api" {
  rest_api_id = aws_api_gateway_rest_api.public_api.id
}

resource "aws_api_gateway_stage" "public_api" {
  deployment_id = aws_api_gateway_deployment.public_api.id
  rest_api_id   = aws_api_gateway_rest_api.public_api.id
  stage_name    = var.environment
}

resource "aws_api_gateway_method_settings" "public_api" {
  rest_api_id = aws_api_gateway_rest_api.public_api.id
  stage_name  = aws_api_gateway_stage.public_api.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }

}

# Create a custom domain name for public api gateway
resource "aws_api_gateway_domain_name" "public_api" {
  domain_name              = "api.${var.domain_name}"
  regional_certificate_arn = var.public_api_tls_cert_arn
  endpoint_configuration {
    types = [
    "REGIONAL"]
  }
}

# Create a base path mapping for the public api custom domain
resource "aws_api_gateway_base_path_mapping" "custom_domain_mapping" {
  api_id      = aws_api_gateway_rest_api.public_api.id
  stage_name  = aws_api_gateway_stage.public_api.stage_name
  domain_name = aws_api_gateway_domain_name.public_api.id
}

# Create a Route 53 record for your custom domain
resource "aws_route53_record" "custom_domain_record" {
  zone_id = var.public_hosted_zone_id
  name    = "api.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_api_gateway_domain_name.public_api.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.public_api.regional_zone_id
    evaluate_target_health = false
  }
}

# Create public api gateway API key
resource "aws_api_gateway_api_key" "public_api" {
  name        = "beta-api-key"
  description = "Beta API key for testing"
}

# Create public api usage plan
resource "aws_api_gateway_usage_plan" "public_api" {
  name        = "beta-usage-plan"
  description = "Beta usage plan for public api testing"

  quota_settings {
    limit  = 50
    period = "MONTH"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }

  api_stages {
    api_id = aws_api_gateway_rest_api.public_api.id
    stage  = aws_api_gateway_stage.public_api.stage_name
  }
}

# Associate the public api usage plan with the API key
resource "aws_api_gateway_usage_plan_key" "public_api" {
  key_id        = aws_api_gateway_api_key.public_api.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.public_api.id
}

# Create public api resource server
resource "aws_cognito_resource_server" "resource" {
  identifier = "https://api.${var.domain_name}"
  name       = "public-api-beta-rs"
  scope {
    scope_name        = "Read"
    scope_description = "Read scope"
  }
  user_pool_id = var.user_pool_id
}

resource "aws_cognito_user_pool_client" "public_api_client" {
  name                                 = "beta-public-api-client"
  user_pool_id                         = var.user_pool_id
  generate_secret                      = true
  allowed_oauth_flows                  = ["client_credentials"]
  explicit_auth_flows                  = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["https://api.${var.domain_name}/Read"]
  depends_on                           = [aws_cognito_resource_server.resource]
}
