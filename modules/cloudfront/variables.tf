# modules/cloudfront/variables.tf

variable "alb_dns_name" {
  description = "ALB DNS 이름 (CloudFront 오리진 설정용)"
  type        = string
}

variable "tags" {
  description = "리소스 태그"
  type        = map(string)
  default     = {}
}
