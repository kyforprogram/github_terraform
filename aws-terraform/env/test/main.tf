locals {
  vpc_cidr = "10.0.0.0/16"

  tags = {
    Managed     = "terraform"
    Environment = var.enviroment_name
    Project     = var.project_name
  }
}

################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "../../module/vpc"

  name       = "${var.project_name}-vpc"
  cidr_block = local.vpc_cidr

  tags = local.tags

}