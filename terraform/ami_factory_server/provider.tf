provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.7"
}

terraform {
  required_version = ">= 0.12.12"

  backend "s3" {
    bucket  = "dm-vpc-states"
    key     = "image_builder/ami_builder.tfstates"
    region  = "eu-west-1"
    encrypt = "true"
  }
}