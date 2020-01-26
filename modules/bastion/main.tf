provider "aws" {
  region = var.region
}



data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  ingress_rules       = var.ingress_rules
  ingress_cidr_blocks = var.ingress_cidr_blocks
  egress_rules        = var.egress_rules
}

#resource "aws_eip" "this" {
#  vpc      = true
#  instance = module.ec2.id[0]
#}

#resource "aws_placement_group" "web" {
#  name     = "hunky-dory-pg"
#  strategy = "cluster"
#}

#resource "aws_kms_key" "this" {
#}

locals {
  user_data = <<EOF
#
EOF
}

module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  instance_count = 1

  name                        = var.bastion_name
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  associate_public_ip_address = true
  #placement_group             = aws_placement_group.web.id

  iam_instance_profile = var.iam_instance_profile

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = var.root_size
    },
  ]

  #  ebs_block_device = [
  #    {
  #      device_name = "/dev/sdf"
  #      volume_type = "gp2"
  #      volume_size = 5
  #      encrypted   = true
  #      kms_key_id  = aws_kms_key.this.arn
  #    }
  #  ]

  #user_data_base64 = base64encode(local.user_data)

  user_data = file("bootstrap.sh")

  tags = {
    environment = var.ambiente
    owner       = var.owner
    project     = var.project
    terraform   = "true"
  }
}


