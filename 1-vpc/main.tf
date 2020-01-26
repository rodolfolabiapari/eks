provider "aws" {
  # access_key = var.access_key
  # secret_key = var.secret_key
  region = var.region
}

data "aws_caller_identity" "current" {
}


resource "aws_key_pair" "ssh" {
  key_name   = var.bastion_name
  public_key = file(var.path_bastion_key)
}

module "eks_vpc" {
  source             = "../modules/vpc"
  cidr               = var.cidr
  vpcname            = var.vpc_name
  enable_nat_gateway = true
  ambiente           = var.ambiente
  bastion_key        = aws_key_pair.ssh.key_name

  owner   = var.owner
  project = var.project
}



# role para acesso ao eks
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion_profile"
  role = aws_iam_role.eks_access_role.name
}

module "bastion" {
  source       = "../modules/bastion"
  bastion_name = var.bastion_name
  vpc_id       = module.eks_vpc.vpc_id
  #security_group_id = module.bastion_host_sg.this_security_group_id
  subnet_id    = module.eks_vpc.public_subnets[0]
  ssh_key_name = aws_key_pair.ssh.key_name
  #allowed_cidr_blocks = [
  #  {
  #    rule        = "ssh-tcp"
  #    cidr_blocks = "0.0.0.0/0"
  #    description = "Allow World"
  #}]



  iam_instance_profile = aws_iam_instance_profile.bastion_profile.name

  ingress_rules       = var.sg_ingress_rules
  ingress_cidr_blocks = var.sg_ingress_cidr_blocks
  egress_rules        = var.sg_egress_rules

  ambiente = var.ambiente
  owner    = var.owner
  project  = var.project

}
