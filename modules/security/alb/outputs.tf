// module/sg_alb/outputs.tf
output "alb_sg_id" {
  value = aws_security_group.alb.id
}