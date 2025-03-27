# /modules/route53/main.tf

resource "aws_route53_record" "main" {
  # 사용할 Route 53 호스팅 영역의 ID
  zone_id = var.zone_id

  # 연결할 도메인 이름 (예: www.example.com)
  name    = var.domain_name
  type    = "A"

  # CloudFront와의 연결을 위한 alias 설정
  alias {
    name                   = var.cloudfront_domain         # CloudFront 배포 도메인 이름
    zone_id                = "Z2FDTNDATAQYW2"              # CloudFront의 고정 Hosted Zone ID
    evaluate_target_health = false
  }
} 
