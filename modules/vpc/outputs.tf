# modules/vpc/outputs.tf

# VPC 모듈의 출력을 정의합니다.
output "vpc_id" {
  value = aws_vpc.main.id
}

# Public, Private Subnet의 ID를 출력합니다.
output "public_subnets_ids" {
  value = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  value = aws_subnet.private_app[*].id
}

output "private_db_subnet_ids" {
  value = aws_subnet.private_db[*].id
}

# Internet Gateway, NAT Gateway, Route Table의 ID를 출력합니다.
output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_app_route_table_id" {
  value = aws_route_table.private_app.id
}

output "private_db_route_table_id" {
  value = aws_route_table.private_db.id
}