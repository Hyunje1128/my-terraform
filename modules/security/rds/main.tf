// modules/security/rds/main.tf

resource "aws_security_group" "main" {
  name        = var.name
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

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

# Allow OpenVPN server SG access
resource "aws_security_group_rule" "allow_vpn_sg" {
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  source_security_group_id = var.vpn_sg_id
  security_group_id        = aws_security_group.main.id
  description              = "Allow MySQL access from VPN SG"

}