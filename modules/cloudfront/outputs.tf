# modules/cloudfront/outputs.tf

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.main.domain_name
}
