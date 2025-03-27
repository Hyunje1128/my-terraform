# /modules/route53/variables.tf

variable "zone_id" {
  description = "Route 53 호스팅 영역 ID"
  type        = string
}

variable "domain_name" {
  description = "도메인 이름 (예: www.example.com)"
  type        = string
}

variable "cloudfront_domain" {
  description = "CloudFront 배포 도메인 이름"
  type        = string
}
