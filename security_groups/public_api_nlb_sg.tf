resource "aws_security_group" "public_api_nlb_sg" {
  name   = "${var.name}-public-api-sg-nlb-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.default_http_port
    to_port     = var.default_http_port
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 8080
    to_port          = 8080
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.name}-public-api-sg-nlb-${var.environment}"
    Environment = var.environment
  }
}
