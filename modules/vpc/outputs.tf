# modules/vpc/outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnets_ids" {
  value = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  value = aws_subnet.private_app[*].id
}

output "private_db_subnet_ids" {
  value = aws_subnet.private_db[*].id
}