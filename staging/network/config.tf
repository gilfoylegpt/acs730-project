terraform {
  backend "s3" {
    bucket = "acs730-project-bucket"
    key    = "staging/network/terraform.tfstate"
    region = "us-east-1"
  }
}
