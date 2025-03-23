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