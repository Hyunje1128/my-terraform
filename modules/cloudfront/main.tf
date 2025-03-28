# modules/cloudfront/main.tf

resource "aws_cloudfront_distribution" "main" {
  # CloudFront 배포 활성화
  enabled             = true

  # 루트 요청 시 반환할 기본 객체 (예: / → index.html)
  default_root_object = "index.html"

  # 오리진(ALB)을 설정
  origin {
    domain_name = var.alb_dns_name       # ALB의 DNS 이름 (예: alb-123.ap-northeast-2.elb.amazonaws.com)
    origin_id   = "alb-origin"           # 오리진 식별자

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"     # CloudFront → ALB 통신은 HTTP로만
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # 캐시 동작 및 뷰어 정책 설정
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]     # 허용할 HTTP 메서드
    cached_methods   = ["GET", "HEAD"]                # 캐시할 메서드
    target_origin_id = "alb-origin"                   # 연결할 오리진 ID

    viewer_protocol_policy = "redirect-to-https"       # HTTP 요청 시 HTTPS로 리디렉션

    forwarded_values {
      query_string = false       # 쿼리 스트링은 전달하지 않음
      cookies {
        forward = "none"        # 쿠키 전달 안 함
      }
    }
  }

  aliases = var.aliases  # ← 커스텀 도메인 사용

  # 인증서 설정 (ACM 인증서 사용 + 커스텀 도메인 연결)
  viewer_certificate {
    acm_certificate_arn      = var.acm_cert_arn
    ssl_support_method        = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # 지역 제한 없음
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # 태그 (모듈 외부에서 주입)
  tags = var.tags
}
