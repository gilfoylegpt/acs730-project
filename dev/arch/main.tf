provider "aws" {
  region = "us-east-1"
}

module "global" {
  source = "../../modules/global"
}

locals {
  default_tags = merge(
    module.global.default_tags, {
      "Env" = var.env
    }
  )
}

module "dev-arch" {
  source               = "../../modules/network"
  env                  = var.env
  default_tags         = local.default_tags
  prefix               = module.global.prefix
  vpc_cidr             = var.vpc_cidr
  azones               = module.global.azones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

