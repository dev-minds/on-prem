provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.7"
}

terraform {
  required_version = ">= 0.12.12"

  backend "s3" {
    bucket  = "dm-vpc-states"
    key     = "on-prem/terraform.tfstates"
    region  = "eu-west-1"
    encrypt = "true"
  }
}


# CALL TARGET MODULE 
module "s3" {
  source = "git::https://github.com/dev-minds/tf_modules.git//fm_s3_mod?ref=master"

  ami_id             = "ami-09231b65804de93d6"
}
