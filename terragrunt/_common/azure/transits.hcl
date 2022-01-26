terraform {
  source = "${local.base_source_url}?ref=features/AllowFirewallInHub"
}

locals {
  base_source_url      = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/transit"
  environment_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment          = local.environment_vars.locals.environment
  path_split           = split("/", get_terragrunt_dir())                                                                         # path_split: Separates directory into an array/list
  region               = element(local.path_split, length(local.path_split) - 2)                                                  # region: This will take the region path to get the directory name for the region.
  region_vars          = read_terragrunt_config("${dirname(find_in_parent_folders())}/_common/azure/regions/${local.region}.hcl") # region_vars: Reads the _common regions variables so they don't have to be duplicated.
  region_code          = local.region_vars.locals.region_code
  azure_region_code    = local.region_vars.locals.region
  resource_prefix      = "travis-${local.region_code}-transit"
  resource_group_name  = "${local.resource_prefix}-rg"
  vnet_name            = "${local.resource_prefix}-vnet"
  transit_gateway_name = "${local.resource_prefix}-gw"
  firewall_name        = "${local.resource_prefix}-fw"
}

dependency "controller_deployment" {
  config_path = "../../../../management/controller/deployment"
}

dependency "controller_config" {
  config_path = "../../../../management/controller/config"
}

dependency "state" {
  config_path = "../../../../management/state"
}

inputs = {
  location                                  = local.azure_region_code
  resource_group_name                       = local.resource_group_name
  vnet_name                                 = local.vnet_name
  transit_gateway_name                      = local.transit_gateway_name
  transit_gateway_ha                        = true
  enable_transit_gateway_scheduled_shutdown = true
  insane_mode                               = false
  firenet_enabled                           = true
  firewall_name                             = local.firewall_name
  egress_enabled                            = true
  firewall_image                            = "Fortinet FortiGate (PAYG_20190624) Next-Generation Firewall Latest Release"
  firewall_image_version                    = "7.0.3"
  firewall_ha                               = true
  key_vault_id                              = dependency.state.outputs.key_vault_id
  aviatrix_azure_account                    = dependency.controller_config.outputs.aviatrix_azure_account
  user_public_for_mgmt                      = dependency.controller_config.outputs.user_public_ip_address
  controller_public_ip                      = dependency.controller_deployment.outputs.controller_public_ip
  controller_username                       = "admin"
  controller_password                       = dependency.controller_deployment.outputs.controller_admin_password
}