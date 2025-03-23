// modules/openvpn/main.tf

resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type              = var.instance_type
  subnet_id                  = var.subnet_id
  vpc_security_group_ids     = [var.security_group_id]
  key_name                   = var.key_name
  associate_public_ip_address = true # Public IP를 할당받기 위해 true로 설정

  tags = {
    Name = var.name
  }

  user_data = var.user_data

}

// EIP 생성
resource "aws_eip" "openvpn" {
  instance = aws_instance.main.id
}

