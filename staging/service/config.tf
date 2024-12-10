terraform {
  backend "s3" {
    bucket = "acs730-project"
    key    = "staging/service/terraform.tfstate"
    region = "us-east-1"
  }
}
