// modules/s3/variables.tf

variable "bucket_name" {
  type        = string
  description = "GitHub Actions 배포용 S3 버킷 이름"
}

variable "github_iam_arn" {
  type        = string
  description = "GitHub Actions에서 사용하는 IAM 사용자의 ARN"
}
