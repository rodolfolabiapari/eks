
# aws

variable "region" {
  default = "us-east-1"
}


variable "sg_name" {
  default = "bastion-eks"
}


variable "sg_description" {
  default = "Security group for example usage with EC2 instance"
}



# bastion
variable "bastion_name" {
  type    = string
  default = "bastion"
}

variable "iam_instance_profile" {
  default = ""
}

variable "vpc_id" {
}

variable "subnet_id" {
}

variable "ssh_key_name" {
}

#variable "allowed_cidr_blocks" {
#}

variable "root_size" {
  default = 15
}

variable "instance_type" {
  default = "t2.medium"
}


variable "ingress_rules" {
}
variable "ingress_cidr_blocks" {
}
variable "egress_rules" {
}

#variable "rule" {
#}
#variable "cidr_blocks" {
#}
#variable "description" {
#}

variable "ambiente" {
  default = "dev"
}


variable "project" {
  default = "project_name"
}

variable "owner" {
  default = "owner_name"
}
