resource "aws_security_group" "public_api_ecs_service_sg" {
  name = "public_api_ecs_service_sg"

  vpc_id = var.vpc_id

  # allow ingress to the app port from anywhere in the VPC
  ingress {
    protocol    = "tcp"
    from_port   = var.spring_boot_app_port
    to_port     = var.spring_boot_app_port
    cidr_blocks = [var.vpc_cidr]
  }

  # allow ingress to the management port from anywhere in the VPC
  ingress {
    protocol    = "tcp"
    from_port   = var.spring_boot_management_port
    to_port     = var.spring_boot_management_port
    cidr_blocks = [var.vpc_cidr]
  }

  # Ability to talk to anything including internet access
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
