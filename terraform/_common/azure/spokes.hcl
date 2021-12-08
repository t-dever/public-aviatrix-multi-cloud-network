# This specifies the default tag/reference for the spoke module
terraform {
  source = "${local.base_source_url}?ref=features/addAzureSpokes"
}

# These are the spoke level variables
locals {
  base_source_url = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/spokes"
  env = local.environment_vars.locals.environment
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_path = split("/", get_terragrunt_dir())
  region = element(local.region_path, length(local.region_path)-3)
  region_vars = read_terragrunt_config("${dirname(find_in_parent_folders())}/_common/azure/regions/${local.region}.hcl") 
}

dependency "state" {
  config_path = "../../../../management/state"
}

dependency "controller" {
  config_path = "../../../../management/controller"
}

dependency "hub" {
  config_path = "../../hub"
}

dependencies {
  ["../../hub"]
}

inputs = {
  location               = local.region_vars.locals.region,
  controller_public_ip   = dependency.controller.outputs.controller_public_ip
  controller_password    = dependency.controller.outputs.controller_admin_password
  aviatrix_azure_account = dependency.controller.outputs.aviatrix_azure_account
  key_vault_id           = dependency.state.outputs.key_vault_id
  transit_gateway_name   = dependency.hub.outputs.transit_gateway_name
}