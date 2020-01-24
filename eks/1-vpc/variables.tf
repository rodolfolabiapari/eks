# AWS
variable "region" {
  default = "us-east-1"
}

# VPC
variable "cidr" {
  default = "10.21.0.0/16"
}
variable "vpc_name" {
  default = "vpc"
}
variable "ambiente" {
  default = "dev"
}

# Bastion

variable "bastion_name" {
  default = "bastion"
}

variable "path_bastion_key" {
  default = "key.pub"
}

variable "sg_ingress_rules" {
}
variable "sg_ingress_cidr_blocks" {
}
variable "sg_egress_rules" {
}

variable "project" {
}

variable "owner" {

}

