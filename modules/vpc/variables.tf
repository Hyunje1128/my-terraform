# modules/vpc/variables.tf
variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_app_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "private_db_subnets" {
  type = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}
