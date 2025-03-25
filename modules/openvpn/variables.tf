// modules/openvpn/variables.tf

variable "name" {
  type = string
}

variable "ami_id" {
  type = string
  description = "Amazon Linux AMI or custom OpenVPN AMI ID"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
  description = "EC2 key pair name"
}

variable "user_data" {
  type        = string
  description = "User data script to install OpenVPN"
  default     = ""
}

variable "pre_allocated_eip_id" {
  type = string
  description = "고정된 EIP ID (eipalloc-xxxx)"
}

variable "pre_allocated_eip_address" {  
  type        = string
  description = "고정된 EIP 주소 (예: 43.200.118.179)"
}
