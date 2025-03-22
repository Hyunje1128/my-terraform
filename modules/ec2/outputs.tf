// modules/ec2/outputs.tf

output "asg_name" {
  value = aws_autoscaling_group.main.name
}

output "launch_template_id" {
  value = aws_launch_template.main.id
}