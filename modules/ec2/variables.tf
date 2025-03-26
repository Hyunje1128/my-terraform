// modules/ec2/variables.tf

variable "name" {
  type        = string
  description = "ASG and EC2 name"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "Key pair name"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for ASG"
}

variable "user_data" {
  type        = string
  default     = ""
  description = "EC2 bootstrap script"
}

variable "desired_capacity" {
  type        = number
  default     = 2
}

variable "max_size" {
  type        = number
  default     = 3
}

variable "min_size" {
  type        = number
  default     = 1
}

variable "target_group_arn" {
  type        = string
  description = "ALB Target Group ARN"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "aws_iam_instance_profile_name" {
  description = "EC2에 연결할 IAM 역할 이름 (예: CodeDeploy용)"
  type        = string
}
