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

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "acs730-project-bucket"
    key    = "${var.env}/network/terraform.tfstate"
    region = "us-east-1"
  }
}

module "dev-keypair" {
  source       = "../../modules/keypair"
  env          = var.env
  prefix       = module.global.prefix
  default_tags = local.default_tags
}

module "dev-securitygroup" {
  source            = "../../modules/securitygroup"
  env               = var.env
  prefix            = module.global.prefix
  default_tags      = local.default_tags
  network_datablock = data.terraform_remote_state.network
}

module "dev-instance" {
  source               = "../../modules/instance"
  env                  = var.env
  instance_type        = var.instance_type
  instance_image_id    = module.global.latest_amazon_linux.id
  prefix               = module.global.prefix
  default_tags         = local.default_tags
  network_datablock    = data.terraform_remote_state.network
  public_websg_id      = module.dev-securitygroup.public_websg_id
  private_websg_id     = module.dev-securitygroup.private_websg_id
  private_onlysshsg_id = module.dev-securitygroup.private_onlysshsg_id
  ssh_key_pair_name    = module.dev-keypair.sshkey_name
}

module "dev-loadblancer" {
  source            = "../../modules/loadbalancer"
  env               = var.env
  prefix            = module.global.prefix
  default_tags      = local.default_tags
  public_websg_id   = module.dev-securitygroup.public_websg_id
  network_datablock = data.terraform_remote_state.network
  instance_id_list  = [module.dev-instance.public_instance_ids[0], module.dev-instance.public_instance_ids[1]]
}

module "dev-asg" {
  source            = "../../modules/autoscalinggroup"
  env               = var.env
  instance_type     = var.instance_type
  default_tags      = local.default_tags
  prefix            = module.global.prefix
  network_datablock = data.terraform_remote_state.network
  target_group_arn  = module.dev-loadblancer.target_group_arn
  key_name          = module.dev-keypair.sshkey_name
  public_websg_id   = module.dev-securitygroup.public_websg_id
}
