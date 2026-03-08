locals {
  name     = "terraform-test"
  vpc_cidr = "10.0.0.0/16"

  subnets = {
    public_1a = {
      type = "public"
      az   = "us-east-1a"
      cidr = "10.0.1.0/24"
    }

    public_1b = {
      type = "public"
      az   = "us-east-1b"
      cidr = "10.0.2.0/24"
    }

    private_1a = {
      type = "private"
      az   = "us-east-1a"
      cidr = "10.0.10.0/24"
    }

    private_1b = {
      type = "private"
      az   = "us-east-1b"
      cidr = "10.0.20.0/24"
    }

    private_db_1a = {
      type = "private_db"
      az   = "us-east-1a"
      cidr = "10.0.100.0/24"
    }

    private_db_1b = {
      type = "private_db"
      az   = "us-east-1b"
      cidr = "10.0.120.0/24"
    }
  }

  tags = {
    Managed     = "terraform"
    Environment = "test"
  }
}

################################################################################
# VPC
################################################################################
module "vpc" {
  source = "../../modules/vpc"

  name       = local.name
  cidr_block = local.vpc_cidr
  subnets    = local.subnets

  tags = local.tags

}