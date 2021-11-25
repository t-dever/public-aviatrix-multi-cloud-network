terraform {
  source = "${local.base_source_url}?ref=v1.0.1"
}

locals {
  base_source_url = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/hub"
  env = local.environment_vars.locals.environment
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  # region_path: Separates directory into an array/list
  region_path = split("/", get_terragrunt_dir()) 
  # region: This will take the region path to get the directory name for the region.
  region = element(local.region_path, length(local.region_path)-2)
  # region_vars: Reads the _common regions variables so they don't have to be duplicated.
  region_vars = read_terragrunt_config("${dirname(find_in_parent_folders())}/_common/azure/regions/${local.region}.hcl") 
}

dependency "controller" {
  config_path = "../../../management/controller"
}

dependency "state" {
  config_path = "../../../management/state"
}

inputs = {
  location                  = local.region_vars.locals.region,
  controller_public_ip      = dependency.controller.outputs.controller_public_ip
  controller_admin_password = dependency.controller.outputs.controller_admin_password
  key_vault_id              = dependency.state.outputs.key_vault_id
  aviatrix_azure_account    = local.environment_vars.locals.aviatrix_azure_account
  key_vault_id              = local.environment_vars.locals.key_vault_id
  user_public_for_mgmt      = local.environment_vars.locals.user_public_for_mgmt
}