terraform {
  source = "${local.base_source_url}"
}

locals {
  base_source_url  = "${dirname(find_in_parent_folders())}/_common/modules//segmentation"
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

dependency "controller_deployment" {
  config_path = "../../management/controller/deployment"
}

inputs = {
  segmentation_domain_name = local.env
  controller_public_ip     = dependency.controller_deployment.outputs.controller_public_ip
  controller_username      = "admin"
  controller_password      = dependency.controller_deployment.outputs.controller_admin_password
}