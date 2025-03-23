// modules/security/openvpn/outputs.tf

output "sg_id" {
  value = aws_security_group.main.id
}