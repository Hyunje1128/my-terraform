// modules/security/rds/outputs.tf

output "sg_id" {
  description = "The ID of the security group allowing VPN access"
  value = aws_security_group.main.id
}