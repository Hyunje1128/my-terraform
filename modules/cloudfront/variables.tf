# modules/cloudfront/variables.tf

variable "alb_dns_name" {
  description = "ALB DNS 이름 (CloudFront 오리진 설정용)"
  type        = string
}

variable "aliases" {
  type        = list(string)
  description = "CloudFront 커스텀 도메인 목록"
}

variable "acm_cert_arn" {
  type        = string
  description = "ACM 인증서 ARN (us-east-1)"
}

variable "tags" {
  description = "리소스 태그"
  type        = map(string)
  default     = {}
}
