// modules/security/rds/variables.tf

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ec2_sg_id" {
  type = string
  description = "EC2 인스턴스가 속한 보안 그룹 ID"
}

variable "db_port" {
  type    = number
  default = 3306
  description = "DB 접근 포트 (MySQL: 3306, PostgreSQL: 5432 등)"
}
