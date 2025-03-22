// modules/security/ec2/variables.tf

variable "name" {
  type        = string
  description = "Security group name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the security group"
}

variable "alb_sg_id" {
  type        = string
  description = "ALB security group ID (source for HTTP)"
}

variable "ssh_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed to SSH"
}