terraform {
  backend "s3" {
    bucket = "terraformexe"
    key    = "statefile/terraform.tfstate"
    region = "us-east-1"
  }
}