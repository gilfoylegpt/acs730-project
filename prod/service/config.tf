terraform {
  backend "s3" {
    bucket = "acs730-project"
    key    = "prod/service/terraform.tfstate"
    region = "us-east-1"
  }
}
