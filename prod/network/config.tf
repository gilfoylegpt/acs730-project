terraform {
  backend "s3" {
    bucket = "acs730-project"
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}
