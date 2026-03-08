locals {
  vpc_cidr = "10.0.0.0/16"

  name = "${var.project_name}-${var.enviroment_name}"
  tags = {
    Managed     = "terraform"
    Environment = var.enviroment_name
    Project     = var.project_name
  }
}

################################################################################
# VPC Module
########te########################################################################
module "vpc" {
  source = "../../modules/vpc"

  name       = local.name
  cidr_block = local.vpc_cidr

  tags = local.tags

}