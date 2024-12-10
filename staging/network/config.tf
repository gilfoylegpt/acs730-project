terraform {
  backend "s3" {
    bucket = "acs730-project"
    key    = "staging/network/terraform.tfstate"
    region = "us-east-1"
  }
}
