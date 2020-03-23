locals {
    environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    env = local.environment_vars.locals.environment 
}

terraform {
    source = "git::https://github.com/dev-minds/tf_modules.git//fm_vpc_mod?ref=master"
    // source = "git::https://github.com/dev-minds/dm_tf_base_modules.git//services/tf_fe_dev?ref=v0.0.2"
}

include {
    path = find_in_parent_folders()
}

inputs = {
    vpc_name = "prod"
    cidr_block = "10.100.0.0/16"
    availability_zones = ["eu-west-1a"]
    aws_region  = "eu-west-1"
    name_tag    = "prod"
}