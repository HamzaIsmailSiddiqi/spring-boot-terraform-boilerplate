resource "aws_lb" "public_api_nlb" {
  name               = "${var.name}-public-api-nlb-${var.environment}"
  internal           = true
  load_balancer_type = "network"
  security_groups    = var.nlb_security_groups
  subnets            = var.subnets.*.id
  idle_timeout       = var.idle_timeout_seconds

  enable_deletion_protection = false

  tags = {
    Name        = "${var.name}-public-api-nlb-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "public_api_nlb_tg" {
  depends_on = [
    aws_lb.public_api_nlb
  ]
  name        = "${var.name}-public-api-nlb-tg-${var.environment}"
  port        = var.public_api_app_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    protocol            = "HTTP"
    port                = var.public_api_health_check_port
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}
# Redirect all traffic from the NLB to the target group
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.public_api_nlb.id
  port              = var.public_api_app_port
  protocol          = "TCP"
  default_action {
    target_group_arn = aws_lb_target_group.public_api_nlb_tg.id
    type             = "forward"
  }
}
