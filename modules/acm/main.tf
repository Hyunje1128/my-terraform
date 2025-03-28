# modules/acm/main.tf

# 버지니아(us-east-1) 리전에서 ACM 인증서 생성 (CloudFront 전용)
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

# 도메인용 SSL 인증서 요청 (DNS 검증 방식)
resource "aws_acm_certificate" "main" {
  provider          = aws.virginia
  domain_name       = var.domain_name            # 예: www.rok-lee.com
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true                 # 인증서 교체 시 다운타임 방지
  }

  tags = var.tags
}

# Route 53에 DNS 검증 레코드 자동 생성
resource "aws_route53_record" "validation" {
  name    = join(".", slice(split(".", tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_name), 0, 2))
  type    = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_type
  zone_id = var.route53_zone_id
  records = [tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_value]
  ttl     = 300
}

# 인증서 DNS 검증 완료 리소스
resource "aws_acm_certificate_validation" "main" {
  provider                = aws.virginia
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [aws_route53_record.validation.fqdn]
}