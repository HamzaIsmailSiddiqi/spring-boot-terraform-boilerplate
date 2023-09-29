output "public_hosted_zone_id" {
  value = aws_route53_zone.public_zone.id
}

output "private_hosted_zone_id" {
  value = aws_route53_zone.private_zone.id
}

output "private_hosted_zone_name" {
  value = aws_route53_zone.private_zone.name
}

output "wildcard_certificate" {
  value = aws_acm_certificate.wildcard_certificate
}

output "wildcard_certificate_arn" {
  value = aws_acm_certificate.wildcard_certificate.arn
}

output "vpc" {
  value = aws_vpc.ps_vpc
}

output "vpc_id" {
  value = aws_vpc.ps_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets
}

output "private_subnets" {
  value = aws_subnet.private_subnets
}

output "public_hosted_zone" {
  value = aws_route53_zone.public_zone
}

output "private_hosted_zone" {
  value = aws_route53_zone.private_zone
}
