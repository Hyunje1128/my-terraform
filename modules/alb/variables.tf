// modules/alb/variables.tf

variable "name" {
  description = "ALB name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "target_port" {
  description = "Target group port (usually 80)"
  type        = number
}

variable "security_group_id" {
  description = "Security group ID to attach to the ALB"
  type        = string
}
