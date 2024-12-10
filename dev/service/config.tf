terraform {
  backend "s3" {
    bucket = "acs730-project"
    key    = "dev/service/terraform.tfstate"
    region = "us-east-1"
  }
}
