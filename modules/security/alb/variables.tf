// modules/security/variables.tf
variable "name" {
  description = "Security group name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}
