// modules/openvpn/main.tf

resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type              = var.instance_type
  subnet_id                  = var.subnet_id
  vpc_security_group_ids     = [var.security_group_id]
  key_name                   = var.key_name

  tags = {
    Name = var.name
  }

  user_data = var.user_data

}

// aws 콘솔에서 eip 할당하고 사용(고정ip)
resource "aws_eip_association" "vpn_eip_association" {
  instance_id   = aws_instance.main.id
  allocation_id = var.pre_allocated_eip_id
  
}