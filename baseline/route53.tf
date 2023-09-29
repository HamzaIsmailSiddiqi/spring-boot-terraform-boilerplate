resource "aws_route53_zone" "public_zone" {
  name = var.domain_name
}
resource "aws_route53_zone" "private_zone" {
  name = "vpc.internal"

  vpc {
    vpc_id = aws_vpc.ps_vpc.id
  }
}
