# module/acm/outputs.tf

# 인증서 ARN 출력 (CloudFront에서 참조)
output "acm_certificate_arn" {
  value = aws_acm_certificate.main.arn
}