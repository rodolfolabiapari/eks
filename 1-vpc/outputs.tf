output "vpc_id" {
  value = module.eks_vpc.vpc_id
}
output "vpc_cidr" {
  value = module.eks_vpc.vpc_cidr
}

output "vpc_private_sub" {
  value = module.eks_vpc.private_subnets
}

output "vpc_public_sub" {
  description = "List of IDs of public subnets"
  value       = module.eks_vpc.public_subnets
}

#output "bastion_ip" {
#  value = module.bastion.public_ip
#}
#
#output "bastion_sg" {
#  value = module.bastion.security_groups
#}

output "vpc_azs" {
  value = module.eks_vpc.azs
}

output "vpc_public_sub_cidr" {
  value = module.eks_vpc.public_subnets_cidr_blocks
}

output "vpc_private_sub_cidr" {
  value = module.eks_vpc.private_subnets_cidr_blocks
}


# Outputs para o Caller ID
output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "account_caller_arn" {
  value = "${data.aws_caller_identity.current.arn}"
}

output "accoutn_caller_user" {
  value = "${data.aws_caller_identity.current.user_id}"
}


