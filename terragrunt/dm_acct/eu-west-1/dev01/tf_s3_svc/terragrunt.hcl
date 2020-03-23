locals {
    environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    env = local.environment_vars.locals.environment 
}

terraform {
    source = "git::https://github.com/dev-minds/tf_modules.git//fm_s3_mod?ref=master"
    // source = "git::https://github.com/dev-minds/dm_tf_base_modules.git//services/tf_fe_dev?ref=v0.0.2"
}

include {
    path = find_in_parent_folders()
}

inputs = {
    bucket_name     = "dminds-dev01-buckets-covid19"
    force_destroy   = "true"
    versionnig      = "false" 
}
