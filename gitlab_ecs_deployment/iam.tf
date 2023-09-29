data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [var.dev_iam_role_arn]
    }
  }
}

resource "aws_iam_role" "ecs_role" {
  name               = "GitLabECSFullAccessRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "ecs_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ecs:*"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ssm:PutParameter"]
    resources = ["arn:aws:ssm:${var.region}:${var.account}:parameter/*"]
  }

  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      "arn:aws:iam::${var.account}:role/*EcsTaskRole",
      "arn:aws:iam::${var.account}:role/*EcsTaskExecutionRole"
    ]
  }
}

resource "aws_iam_policy" "ecs_policy" {
  name        = "GitLabECSFullAccessPolicy"
  description = "Policy granting full access to ECS"
  policy      = data.aws_iam_policy_document.ecs_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.ecs_policy.arn
}
