# /modules/cicd/codedeploy/variables.tf

variable "iam_role_name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "deployment_group_name" {
  type = string
}

variable "ec2_tag_key" {
  type = string
}

variable "ec2_tag_value" {
  type = string
}

variable "service_role_arn" {
  type        = string
  description = "IAM Role ARN to be used by CodeDeploy"
}