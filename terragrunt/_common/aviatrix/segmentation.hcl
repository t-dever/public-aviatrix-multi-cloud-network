terraform {
  source = "${local.base_source_url}"
}

locals {
  base_source_url  = "${dirname(find_in_parent_folders())}/_common/modules//segmentation"
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

dependency "controller" {
  config_path = "../management/controller"
}

inputs = {
  segmentation_domain_name = local.env
}