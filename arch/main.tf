provider "aws" {
  region = "us-east-1"
}

module "global" {
  source = "../modules/global"
}

locals {
  default_tags = merge(
    module.global.default_tags, {
      "Env" = var.env
    }
  )
}

module "arch" {
  source               = "../modules/network"
  env                  = var.env
  default_tags         = local.default_tags
  prefix               = module.global.prefix
  vpc_cidr             = lookup(var.vpc_cidr, var.env)
  azones               = module.global.azones
  public_subnet_cidrs  = lookup(var.public_subnet_cidrs, var.env)
  private_subnet_cidrs = lookup(var.private_subnet_cidrs, var.env)
}
