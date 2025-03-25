// modules/security/openvpn/main.tf

resource "aws_security_group" "main" {
  name        = var.name
  description = "Security group for OpenVPN EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  ingress {
    description = "HTTPS - Web UI / VPN Client"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 또는 제한된 IP 대역으로 설정 가능
  }

  ingress {
    description = "Admin Web UI"
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow OpenVPN (UDP 1194)"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = var.vpn_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name
  }
}