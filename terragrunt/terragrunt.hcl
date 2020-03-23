locals {
    account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl")) 
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl")) 
    environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))


    account_name = local.account_vars.locals.account_name
    account_id  = local.account_vars.locals.aws_account_id
    aws_region  = local.region_vars.locals.aws_region
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
provider "aws" {
    region = "${local.aws_region}"
    
}
EOF
}

remote_state {
    backend = "s3"
    config = {
        encrypt     = true 
        bucket      = "${get_env("TG_BUCKET_PREFIX", "")}-tg-dm-acct-state-${local.aws_region}"
        key         = "${path_relative_to_include()}/terraform.tfstate"
        region      = local.aws_region
        dynamodb_table = "terraform-locks"
    }
    generate = {
        path        = "backend.tf"
        if_exists   = "overwrite_terragrunt"
    }
}