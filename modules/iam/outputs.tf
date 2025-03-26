// modules/iam/outputs.tf

output "github_iam_arn" {
  description = "IAM 사용자 ARN"
  value       = aws_iam_user.github.arn
}

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

output "ec2_instance_profile_name" {
  description = "EC2 인스턴스에 연결할 IAM 인스턴스 프로파일 이름"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "ec2_iam_role_arn" {
  description = "EC2 인스턴스에 할당된 IAM 역할의 ARN"
  value       = aws_iam_role.ec2_instance_role.arn
}


