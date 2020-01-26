provider "aws" {
  # access_key = var.access_key
  # secret_key = var.secret_key
  region = var.region
}

data "aws_caller_identity" "current" {
}

# Este pedaco de codigo utiliza o state passado (do vpc)
# como entrada pra este modulo e sera utilizado para popular dados de vpc aqui
# Este codigo nao modifica o backend do arquivo terraform.tf
data "terraform_remote_state" "infraestrutura" {
  backend = "s3"
  config = {
    bucket = "lxp-terraform-states"
    key    = "rodolfos/dev/learningeks/vpc_bastion/terraform.tfstate"
    region = "us-east-1"
  }
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.10" #version of the provider, not kubernetes
}


module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  cluster_name                    = var.cluster_name
  subnets                         = data.terraform_remote_state.infraestrutura.outputs.private_subnets
  cluster_version                 = var.kubernetes_version
  cluster_endpoint_public_access  = var.public_endpoint_api
  cluster_endpoint_private_access = var.private_endpoint_api

  tags = {
    environment = var.ambiente
    owner       = var.owner
    project     = var.project
    terraform   = "true"
  }

  vpc_id = data.terraform_remote_state.infraestrutura.outputs.vpc_id

  node_groups_defaults = {
    #ami_type  = var.ami_type #"AL2_x86_64"
    disk_size = var.root_size
  }

  #worker_additional_security_group_ids = data.terraform_remote_state.infraestrutura.outputs.bastion_sg

  node_groups = {
    workers = {
      name                  = "general-worker"
      desired_capacity      = 1
      max_capacity          = 2
      min_capacity          = 1
      autoscaling_enable    = "true"
      protect_from_scale_in = "true"

      instance_type = var.instance_type
      k8s_labels = {
        environment    = var.ambiente
        owner          = var.owner
        project        = var.project
        terraform      = "true"
        worker_purpose = "general"
      }
      additional_tags = {
        environment    = var.ambiente
        owner          = var.owner
        project        = var.project
        terraform      = "true"
        worker_purpose = "general"
      }
    }
  }


  #  worker_groups_launch_template = [
  #    {
  #      name                 = "worker-temp-1"
  #      instance_type        = "t2.small"
  #      asg_desired_capacity = 2
  #      #public_ip            = true
  #    },
  #    {
  #      name                 = "worker-temp-2"
  #      instance_type        = "t2.medium"
  #      asg_desired_capacity = 1
  #      #public_ip            = true
  #    },
  #  ]
  #
  #  worker_groups = [
  #    {
  #      name                          = "worker-group-1"
  #      instance_type                 = "t2.small"
  #      additional_userdata           = "echo foo bar"
  #      asg_desired_capacity          = 2
  #      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
  #    },
  #    {
  #      name                          = "worker-group-2"
  #      instance_type                 = "t2.medium"
  #      additional_userdata           = "echo foo bar"
  #      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
  #      asg_desired_capacity          = 1
  #    },
  #  ]

  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts
}
