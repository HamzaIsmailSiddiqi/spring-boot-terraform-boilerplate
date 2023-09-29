output "aws_nlb_arn" {
  value = aws_lb.public_api_nlb.arn
}

output "aws_nlb_tg_arn" {
  value = aws_lb_target_group.public_api_nlb_tg.arn
}

output "aws_nlb_dns_name" {
  value = aws_lb.public_api_nlb.dns_name
}
