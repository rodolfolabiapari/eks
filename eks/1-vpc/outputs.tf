output "vpc_id" {
  value = module.eks_vpc.vpc_id
}
output "vpc_cidr" {
  value = module.eks_vpc.vpc_cidr
}

output "private_subnets" {
  value = module.eks_vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.eks_vpc.public_subnets
}

output "azs" {
  value = module.eks_vpc.azs
}

output "public_subnets_cidr_blocks" {
  value = module.eks_vpc.public_subnets_cidr_blocks
}

output "private_subnets_cidr_blocks" {
  value = module.eks_vpc.private_subnets_cidr_blocks
}


# Outputs para o Caller ID
output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "caller_arn" {
  value = "${data.aws_caller_identity.current.arn}"
}

output "caller_user" {
  value = "${data.aws_caller_identity.current.user_id}"
}