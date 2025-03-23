// modules/rds/main.tf

resource "aws_db_subnet_group" "main" {
  name       = var.name
  subnet_ids = var.subnet_ids

  tags = {
    Name = var.name
  }
}

resource "aws_db_instance" "main" {
  identifier              = var.name
  engine                  = var.engine
  instance_class          = var.instance_class
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [var.security_group_id]
  allocated_storage       = var.allocated_storage
  storage_type            = "gp2"
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  deletion_protection     = false

  tags = {
    Name = var.name
  }
}