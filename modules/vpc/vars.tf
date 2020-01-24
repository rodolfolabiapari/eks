variable "region" {
  default = "us-east-1"
}

variable "cidr" {

}

variable "one_nat_gateway_per_az" {
  default = false
}

variable "vpcname" {
}

variable "ambiente" {
}

variable "enable_nat_gateway" {
  default = false
}

variable "single_nat_gateway" {
  default = true
}
variable "bastion_key" {
  description = "bastion hosts ssh key name"
  type        = string
}

variable "aplicacao" {
  description = "bastion hosts ssh key name"
  type        = string
  default     = "test"
}

variable "project" {
  default = "project_name"
}

variable "owner" {
  default = "owner_name"
}



# bastion

#variable "bastion_name" {
#  type = string
#  default = "bastion"
#}
#
#variable "vpc_id" {
#}
#
#variable "subnet_id" {
#}
#
#variable "ssh_key_name" {
#}
#
#variable "allowed_cidr_blocks" {
#}