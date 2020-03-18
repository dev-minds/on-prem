provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.7"
}

terraform {
  required_version = ">= 0.12.12"

  backend "s3" {
    bucket  = "dm-vpc-states"
    key     = "dm_arci_finale/fe.tfstates"
    region  = "eu-west-1"
    encrypt = "true"
  }
}


# CALL TARGET MODULE 
module "vpc" {
  # https://github.com/hashicorp/terraform/issues/21606
  # source = "git::ssh://git@bitbucket.org/matchesfashion/terraform-modules.git//s3_bucket?ref=master"
  source = "git::https://github.com/dev-minds/tf_modules.git//fm_vpc_mod?ref=master"

  availability_zones = ["eu-west-1a"]
  cidr_block         = "10.20.0.0/16"
  vpc_name           = "dev"
  profile_name       = "default"
  ami_id             = "ami-09231b65804de93d6"
}