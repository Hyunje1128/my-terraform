// modules/openvpn/outputs.tf

output "instance_id" {
  value = aws_instance.main.id
}

output "public_ip" {
  value = aws_instance.main.public_ip
}

output "openvpn_eip" {
  description = "EIP address of the OpenVPN EC2 instance"
  value       = var.pre_allocated_eip_address # 수정
}
