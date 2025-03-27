# /modules/route53/outputs.tf

output "route53_fqdn" {
  description = "전체 도메인 이름"
  value       = aws_route53_record.main.fqdn
}