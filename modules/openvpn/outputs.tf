// modules/openvpn/outputs.tf

output "instance_id" {
  value = aws_instance.main.id
}

output "public_ip" {
  value = aws_instance.main.public_ip
}

output "openvpn_eip" {
  description = "Elastic IP assigned to OpenVPN server"
  value       = aws_eip.openvpn.public_ip
}