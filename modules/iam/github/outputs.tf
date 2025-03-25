// modules/iam/github/outputs.tf

output "iam_user_name" {
  description = "생성된 IAM 사용자 이름"
  value       = aws_iam_user.github.name
}

output "access_key_id" {
  description = "GitHub Actions에서 사용할 AWS Access Key ID"
  value       = aws_iam_access_key.github.id
  sensitive   = true
}

output "secret_access_key" {
  description = "GitHub Actions에서 사용할 AWS Secret Access Key"
  value       = aws_iam_access_key.github.secret
  sensitive   = true
}
