# modules/acm/variable.tf

# 사용할 도메인 이름 (예: www.rok-lee.com)
variable "domain_name" {
  type        = string
  description = "도메인 이름 (예: www.rok-lee.com)"
}

# Route 53의 호스팅 영역 ID
variable "route53_zone_id" {
  type        = string
  description = "Route 53 호스팅 영역 ID"
}

# 공통 태그
variable "tags" {
  type        = map(string)
  default     = {}
}