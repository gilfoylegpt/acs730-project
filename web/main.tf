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

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "acs730-project"
    key    = "${var.env}/network/terraform.tfstate"
    region = "us-east-1"
  }
}

module "keypair" {
  source       = "../modules/keypair"
  env          = var.env
  prefix       = module.global.prefix
  default_tags = local.default_tags
}

module "securitygroup" {
  source            = "../modules/securitygroup"
  env               = var.env
  prefix            = module.global.prefix
  default_tags      = local.default_tags
  network_datablock = data.terraform_remote_state.network
}

module "instance" {
  source               = "../modules/instance"
  env                  = var.env
  instance_type        = var.instance_type
  instance_image_id    = module.global.latest_amazon_linux.id
  prefix               = module.global.prefix
  default_tags         = local.default_tags
  network_datablock    = data.terraform_remote_state.network
  public_websg_id      = module.securitygroup.public_websg_id
  private_websg_id     = module.securitygroup.private_websg_id
  private_onlysshsg_id = module.securitygroup.private_onlysshsg_id
  ssh_key_pair_name    = module.keypair.sshkey_name
}

module "loadbalancer" {
  source            = "../modules/loadbalancer"
  env               = var.env
  prefix            = module.global.prefix
  default_tags      = local.default_tags
  public_websg_id   = module.securitygroup.public_websg_id
  network_datablock = data.terraform_remote_state.network
  instance_id_list  = [module.instance.public_instance_ids[0], module.instance.public_instance_ids[1]]
}

resource "null_resource" "create_ami" {
  provisioner "local-exec" {
    command = <<EOF
    until $(curl --output /dev/null --silent --head --fail http://${module.loadbalancer.load_balancer_dns}:80); do
      sleep 10
    done
    
    EXISTING_AMI_ID=$(aws ec2 describe-images \
      --filters "Name=name,Values=${module.global.prefix}-${var.env}-webserver-ami" \
      --query "Images[0].ImageId" \
      --output text --region us-east-1 || echo "null")

    if [ "$EXISTING_AMI_ID" != "None" ] && [ "$EXISTING_AMI_ID" != "null" ]; then
      echo "Deleting existing AMI: $EXISTING_AMI_ID"
      aws ec2 deregister-image --image-id $EXISTING_AMI_ID --region us-east-1
    else
      echo "No existing AMI found. Skipping deletion."
    fi

    echo "Creating new AMI..."
    aws ec2 create-image --instance-id ${module.instance.public_instance_ids[0]} \
      --name "${module.global.prefix}-${var.env}-webserver-ami" \
      --no-reboot \
      --query 'ImageId' \
      --region us-east-1 \
      --output text > /tmp/${var.env}-ami-id.txt
    EOF
  }

  depends_on = [module.loadbalancer]
}

data "local_file" "ami_id" {
  filename = "/tmp/${var.env}-ami-id.txt"

  depends_on = [null_resource.create_ami]
}

module "autoscalinggroup" {
  source            = "../modules/autoscalinggroup"
  env               = var.env
  instance_type     = var.instance_type
  default_tags      = local.default_tags
  prefix            = module.global.prefix
  network_datablock = data.terraform_remote_state.network
  target_group_arn  = module.loadbalancer.target_group_arn
  key_name          = module.keypair.sshkey_name
  public_websg_id   = module.securitygroup.public_websg_id
  ami_id            = trimspace(data.local_file.ami_id.content)

  depends_on = [null_resource.create_ami]
}
