variable "region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2" # 기본값 설정 (선택)
}

variable "route53_zone_id" {
  description = "Route 53 호스팅 영역 ID"
  type        = string
}

variable "route53_domain_name" {
  description = "Route 53 연결용 도메인 이름"
  type        = string
}

variable "tags" {
  description = "공통 리소스 태그"
  type        = map(string)
  default     = {
    Project     = "my-terraform"
    Environment = "dev"
  }
}
