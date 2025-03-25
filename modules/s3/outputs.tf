// modules/s3/outputs.tf

output "bucket_name" {
  value       = aws_s3_bucket.this.bucket
  description = "생성된 S3 버킷 이름"
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "S3 버킷 ARN"
}
