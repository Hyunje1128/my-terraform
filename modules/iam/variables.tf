// modules/iam/variables.tf

variable "user_name" {
  description = "GitHub Actions에서 사용할 IAM 사용자 이름"
  type        = string
}

variable "ec2_iam_role_name" {
  description = "EC2 인스턴스에 할당할 IAM 역할 이름"
  type        = string
}