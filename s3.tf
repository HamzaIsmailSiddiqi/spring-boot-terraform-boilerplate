resource "aws_s3_bucket" "ps_files_bucket" {
  bucket = var.s3_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "Technetium.io File Storage"
    Environment = "Beta"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ps_files_bucket_sse_config" {
  bucket = aws_s3_bucket.ps_files_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_policy" "allow_ecs" {
  bucket = aws_s3_bucket.ps_files_bucket.id
  policy = data.aws_iam_policy_document.allow_ecs.json
}


data "aws_iam_policy_document" "allow_ecs" {
  statement {
    sid = "AllowApplicationEcsTaskAccess"
    principals {
      type = "AWS"
      identifiers = [
        module.ecs-application-service.ecs_task_role_arn,
        module.ecs-user-service.ecs_task_role_arn
      ]
    }

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.ps_files_bucket.arn}/*",
      aws_s3_bucket.ps_files_bucket.arn

    ]
  }
}

resource "aws_s3_bucket_cors_configuration" "web_app_cors_access" {
  bucket = aws_s3_bucket.ps_files_bucket.id

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["https://app.${var.account_domain_name}"]
    expose_headers  = ["Access-Control-Allow-Origin"]
  }
}
