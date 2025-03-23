// modules/security/openvpn/variables.tf

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ssh_cidr_blocks" {
  type = list(string)
  description = "CIDR blocks allowed to SSH into the instance"
}

variable "vpn_cidr_blocks" {
  type = list(string)
  description = "CIDR blocks allowed to connect to OpenVPN"
}