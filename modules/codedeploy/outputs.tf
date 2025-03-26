# /modules/cicd/codedeploy/outputs.tf

output "codedeploy_app_name" {
  value = aws_codedeploy_app.main.name
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.main.deployment_group_name
}

output "codedeploy_service_role_arn" {
  value       = aws_iam_role.codedeploy_role.arn
  description = "CodeDeploy에 사용되는 IAM Role ARN"
}
