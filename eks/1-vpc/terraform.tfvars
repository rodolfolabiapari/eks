# AWS config
region = "us-east-1"

# VPC CONFIG
cidr     = "10.21.0.0/16"
vpc_name = "rodolfos-eks-dev"
ambiente = "dev"

# BASTION CONFIG
bastion_name     = "rodolfos-bastion-eks"
path_bastion_key = "~/.ssh/KUBE-LXP.pub"

sg_ingress_rules       = ["ssh-tcp"]
sg_ingress_cidr_blocks = ["0.0.0.0/0"]
sg_egress_rules        = ["all-all"]

owner   = "rodolfo"
project = "learningeks"