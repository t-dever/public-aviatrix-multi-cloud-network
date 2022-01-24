# This specifies the default tag/reference for the spoke module
terraform {
  source = "${local.base_source_url}?ref=features/AllowFirewallInHub"
}

# These are the spoke level variables
locals {
  base_source_url           = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/spokes"
  environment_vars          = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env                       = local.environment_vars.locals.environment
  path_split                = split("/", get_terragrunt_dir())
  region                    = element(local.path_split, length(local.path_split) - 3)
  region_vars               = read_terragrunt_config("${dirname(find_in_parent_folders())}/_common/azure/regions/${local.region}.hcl")
  azure_region_code         = local.region_vars.locals.region
  spoke_name                = element(local.path_split, length(local.path_split) - 1)
  region_code               = local.region_vars.locals.region_code
  resource_prefix           = "travis-${local.region_code}-${local.spoke_name}"
  storage_account_name      = "${replace(local.resource_prefix, "-", "")}sa"
  resource_group_name       = "${local.resource_prefix}-rg"
  vnet_name                 = "${local.resource_prefix}-vnet"
  spoke_gateway_name        = "${local.resource_prefix}-gw"
  test_vm_name              = "${local.resource_prefix}-test-vm"
  local_segmentation_domain = "${local.resource_prefix}"
}

dependency "state" {
  config_path = "../../../../../management/state"
}

dependency "controller" {
  config_path = "../../../../../management/controller"
}

dependency "transit" {
  config_path = "../../transit"
}

dependency "segmentation" {
  config_path = "../../../../segmentation"
}

inputs = {
  location                                = local.azure_region_code
  resource_group_name                     = local.resource_group_name
  storage_account_name                    = local.storage_account_name
  vnet_name                               = local.vnet_name
  spoke_gateway_name                      = local.spoke_gateway_name
  test_vm_name                            = local.test_vm_name
  spoke_gw_size                           = "Standard_B1ms"
  firenet_inspection                      = false
  controller_public_ip                    = dependency.controller.outputs.controller_public_ip
  controller_password                     = dependency.controller.outputs.controller_admin_password
  aviatrix_azure_account                  = dependency.controller.outputs.aviatrix_azure_account
  key_vault_id                            = dependency.state.outputs.key_vault_id
  transit_gateway_name                    = dependency.transit.outputs.transit_gateway_name
  firenet_inspection                      = dependency.transit.outputs.firenet_enabled
  segmentation_domain_name                = local.local_segmentation_domain
  segmentation_domain_connection_policies = ["${dependency.segmentation.outputs.segmentation_domain_name}"]
}