# modules/s3/main.tf

resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  force_destroy = true  # 버킷 내 객체 및 버전 모두 자동 삭제 허용

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    principals {
      type        = "AWS"
      identifiers = [var.github_iam_arn]
    }

    resources = [
      "${aws_s3_bucket.main.arn}/*"
    ]
  }
}
