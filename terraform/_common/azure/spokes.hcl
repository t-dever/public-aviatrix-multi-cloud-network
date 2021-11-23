# This specifies the default tag/reference for the spoke module
terraform {
  source = "${local.base_source_url}?ref=features/addAzureSpokes"
}

# These are the spoke level variables
locals {
  base_source_url = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/spokes"
  env = local.environment_vars.locals.environment
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

dependency "hub" {
  config_path = "../../hub"
}

inputs = {
  location               = local.region_vars.locals.region,
  controller_public_ip   = local.environment_vars.locals.controller_public_ip
  controller_password    = get_env("AVIATRIX_CONTROLLER_PASSWORD")
  aviatrix_azure_account = local.environment_vars.locals.aviatrix_azure_account
  key_vault_id           = local.environment_vars.locals.key_vault_id
  transit_gateway_name   = dependency.hub.outputs.transit_gateway_name
}