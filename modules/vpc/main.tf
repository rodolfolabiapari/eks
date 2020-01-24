provider "aws" {
  region = var.region
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.18.0"
  name    = "${var.vpcname}"
  cidr    = "${var.cidr}"

  tags = {
    environment = var.ambiente
    owner       = var.owner
    project     = var.project
    terraform   = "true"
  }

  azs              = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets  = ["${cidrsubnet(var.cidr, 6, 0)}", "${cidrsubnet(var.cidr, 6, 1)}", "${cidrsubnet(var.cidr, 6, 2)}"]
  public_subnets   = ["${cidrsubnet(var.cidr, 8, 12)}", "${cidrsubnet(var.cidr, 8, 13)}", "${cidrsubnet(var.cidr, 8, 14)}"]
  database_subnets = ["${cidrsubnet(var.cidr, 8, 18)}", "${cidrsubnet(var.cidr, 8, 19)}", "${cidrsubnet(var.cidr, 8, 20)}"]

  public_dedicated_network_acl = true
  public_inbound_acl_rules = concat(
    local.network_acls["default_inbound"],
    local.network_acls["public_inbound"],
  )
  public_outbound_acl_rules = concat(
    local.network_acls["default_outbound"],
    local.network_acls["public_outbound"],
  )

  private_dedicated_network_acl = true
  private_inbound_acl_rules = concat(
    local.network_acls["default_inbound"],
    local.network_acls["private_inbound"],
  )
  private_outbound_acl_rules = concat(
    local.network_acls["default_outbound"],
    local.network_acls["private_outbound"],
  )


  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  one_nat_gateway_per_az = "${var.one_nat_gateway_per_az}"
  enable_nat_gateway     = "${var.enable_nat_gateway}"
  enable_vpn_gateway     = false
  single_nat_gateway     = "${var.single_nat_gateway}"

  enable_s3_endpoint = true
  # enable_dynamodb_endpoint = true
  # enable_ecr_api_endpoint  = true
  # ecr_api_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  # enable_ecr_dkr_endpoint  = true
  # ecr_dkr_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  # enable_kms_endpoint      = true
  # kms_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  # enable_monitoring_endpoint = true
  # monitoring_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  # enable_logs_endpoint     = true
  # logs_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  # enable_events_endpoint   = true
  # events_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  # enable_elasticloadbalancing_endpoint = true
  # elasticloadbalancing_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  # enable_sts_endpoint       = true
  # sts_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  # enable_codepipeline_endpoint = true
  # codepipeline_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  # enable_appmesh_envoy_management_endpoint = true
  # appmesh_envoy_management_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  # enable_codecommit_endpoint = true
  # codecommit_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  # enable_sqs_endpoint        = true
  # sqs_endpoint_security_group_ids  = [data.aws_security_group.default.id]
}


locals {
  network_acls = {
    default_inbound = [
      {
        rule_number = 900
        rule_action = "allow"
        from_port   = 1024
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
    default_outbound = [
      {
        rule_number = 900
        rule_action = "allow"
        from_port   = 32768
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
    public_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 120
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 140
        rule_action     = "allow"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
    ]
    public_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 120
        rule_action = "allow"
        from_port   = 1433
        to_port     = 1433
        protocol    = "tcp"
        cidr_block  = "10.0.100.0/22"
      },
      {
        rule_number = 130
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "10.0.100.0/22"
      },
      {
        rule_number = 140
        rule_action = "allow"
        icmp_code   = -1
        icmp_type   = 8
        protocol    = "icmp"
        cidr_block  = "10.0.0.0/22"
      },
      {
        rule_number     = 150
        rule_action     = "allow"
        from_port       = 90
        to_port         = 90
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
    ],
    private_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 120
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 140
        rule_action     = "allow"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
    ]
    private_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 120
        rule_action = "allow"
        from_port   = 1433
        to_port     = 1433
        protocol    = "tcp"
        cidr_block  = "10.0.100.0/22"
      },
      {
        rule_number = 130
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "10.0.100.0/22"
      },
      {
        rule_number = 140
        rule_action = "allow"
        icmp_code   = -1
        icmp_type   = 8
        protocol    = "icmp"
        cidr_block  = "10.0.0.0/22"
      },
      {
        rule_number     = 150
        rule_action     = "allow"
        from_port       = 90
        to_port         = 90
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
    ]
  }
}


