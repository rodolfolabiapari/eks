variable "region" {
  default = "us-east-1"
}

variable "ambiente" {
  default = "dev"
}

variable "cluster_name" {
  default = "eks"
}


variable "owner" {
  default = "owner_name"
}

variable "project" {
  default = "project_name"
}

variable "root_size" {
  default = 50
}

variable "instance_type" {
  default = "m5.xlarge"
}

variable "public_endpoint_api" {
  default = true
}

variable "private_endpoint_api" {
  default = false
}


variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = []
  #  default = [
  #    "777777777777",
  #    "888888888888",
  #  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = []
  #  default = [
  #    {
  #      rolearn  = "arn:aws:iam::66666666666:role/role1"
  #      username = "role1"
  #      groups   = ["system:masters"]
  #    },
  #  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = []
  #  default = [
  #    {
  #      userarn  = "arn:aws:iam::66666666666:user/user1"
  #      username = "user1"
  #      groups   = ["system:masters"]
  #    },
  #    {
  #      userarn  = "arn:aws:iam::66666666666:user/user2"
  #      username = "user2"
  #      groups   = ["system:masters"]
  #    },
  #  ]
}