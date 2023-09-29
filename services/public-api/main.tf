data "aws_iam_policy_document" "ecs_tasks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS Task Role
#
# This role provides permissions to the containers in the task to access other AWS resources,
# such as Amazon S3 buckets, DynamoDB tables, or AWS Systems Manager Parameter Store.
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}EcsTaskRole"

  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role_policy.json

  # Allow the Public API to read it's secrets from secrets manager.
  inline_policy {
    name = "ReadAwsSecrets"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Action" : [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds",
            "secretsmanager:ListSecrets"
          ],
          "Resource" : "arn:aws:secretsmanager:${var.region}:${var.account}:secret:beta/publicApi/*",
          "Effect" : "Allow"
        }
      ]
    })
  }
}

# ECS Task Execution Role
#
# This role allows the ECS service to make API calls on your behalf when it needs to
# manage the lifecycle of tasks, such as pulling container images from Amazon Elastic
# Container Registry (ECR), uploading logs to CloudWatch Logs, or retrieving task metadata.
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}EcsTaskExecutionRole"

  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role_policy.json

  inline_policy {
    name = "ReadEcrImagesFromTest"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Action" : [
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage"
          ],
          "Resource" : var.ecr_repository_arn,
          "Effect" : "Allow"
        },
        {
          "Action" : "ecr:GetAuthorizationToken",
          "Resource" : "*",
          "Effect" : "Allow"
        }
      ]
    })
  }
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "public-api" {
  name              = "ecs/${var.name}"
  retention_in_days = var.log_retention
  tags = {
    Name        = "${var.name}-task-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "service_connect_cloudwatch_log_group" {
  name              = "/ecs/service-connect/${var.name}"
  retention_in_days = var.log_retention
  tags = {
    Name        = "${var.name}-task-service-connect-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "container_version" {
  name  = "/${var.environment}/${var.name}/version"
  type  = "String"
  value = var.ecr_image_version

  # This will allow us to use external build tools (GitLab CI) to control the version.
  lifecycle {
    ignore_changes = [value]
  }
}

data "aws_ssm_parameter" "container_version" {
  name = "/${var.environment}/${var.name}/version"
  depends_on = [
    aws_ssm_parameter.container_version
  ]
}

resource "aws_ecs_task_definition" "public-api" {
  family                   = "${var.name}-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name        = var.name
    image       = "${var.ecr_repository}:${data.aws_ssm_parameter.container_version.value}"
    essential   = true
    environment = var.container_environment
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
      name          = var.name
      }, {
      protocol      = "tcp"
      containerPort = var.prometheus_port
      hostPort      = var.prometheus_port
    }]
    dockerLabels = {
      PROMETHEUS_EXPORTER_PATH = var.prometheus_path
      PROMETHEUS_EXPORTER_PORT = tostring(var.prometheus_port)
    }
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.public-api.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])

  tags = {
    Name        = "${var.name}-task-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "public-api" {
  name                               = var.name
  cluster                            = var.ecs_cluster_id
  task_definition                    = aws_ecs_task_definition.public-api.arn
  desired_count                      = var.service_desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_max_running_tasks_percent
  health_check_grace_period_seconds  = 60
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  force_new_deployment               = false


  network_configuration {
    security_groups  = var.ecs_service_security_groups
    subnets          = var.subnets.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_nlb_target_group_arn
    container_name   = var.name
    container_port   = var.container_port
  }

  # we ignore task_definition changes as the revision changes on deploy
  # of a new version of the application
  # desired_count is ignored as it can change due to autoscaling policy
  lifecycle {
    ignore_changes = [task_definition]
  }

  service_connect_configuration {
    enabled   = true
    namespace = var.namespace

    log_configuration {
      log_driver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.service_connect_cloudwatch_log_group.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }

    service {
      discovery_name = var.name
      port_name      = var.name
      client_alias {
        dns_name = "${var.name}.${var.ecs_connect_namespace}"
        port     = var.container_port
      }
    }
  }
}
