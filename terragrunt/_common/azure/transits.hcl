terraform {
  source = "${local.base_source_url}?ref=${local.source_version}"
}

locals {
  base_source_url       = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/transit"
  source_version        = local.global_vars.source_code_version
  path_split            = split("/", get_terragrunt_dir())                                                                         # path_split: Separates directory into an array/
  environment           = element(local.path_split, length(local.path_split) - 5)
  region                = element(local.path_split, length(local.path_split) - 2)                                                  # region: This will take the region path to get the directory name for the region.
  transit_name          = element(local.path_split, length(local.path_split) - 1)
  global_vars           = yamldecode(file("${dirname(find_in_parent_folders())}/_common/global_vars.yaml"))
  region_vars           = local.global_vars.azure.regions["${local.region}"]
  region_code           = local.region_vars.region_code
  azure_region_location = local.region_vars.location

  network_vars          = yamldecode(file("${dirname(find_in_parent_folders())}/_common/networks.yaml"))
  allowed_public_ips    = local.network_vars.allowed_public_ips
  vnet_address_prefix   = local.network_vars["${local.environment}"]["azure"]["${local.region}"]["transit"]

  resource_prefix       = "travis-${local.region_code}-${local.transit_name}"
  resource_group_name   = "${local.resource_prefix}-rg"
  vnet_name             = "${local.resource_prefix}-vnet"
  transit_gateway_name  = "${local.resource_prefix}-gw"
  firewall_name         = "${local.resource_prefix}-fw"
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
  location                                  = local.azure_region_location
  resource_group_name                       = local.resource_group_name
  vnet_name                                 = local.vnet_name
  vnet_address_prefix                       = local.vnet_address_prefix
  transit_gw_size                           = "Standard_D3_v2"
  transit_gateway_name                      = local.transit_gateway_name
  transit_gateway_ha                        = true
  transit_gateway_az_zone                   = "az-1"
  transit_gateway_ha_az_zone                = "az-2"
  enable_transit_gateway_scheduled_shutdown = true
  insane_mode                               = true
  firenet_enabled                           = false
  firewall_name                             = local.firewall_name
  egress_enabled                            = true
  firewall_image                            = "Fortinet FortiGate (PAYG_20190624) Next-Generation Firewall Latest Release"
  firewall_image_version                    = "7.0.3"
  firewall_ha                               = true
  fw_instance_size                          = "Standard_D3_v2"
  key_vault_id                              = dependency.state.outputs.key_vault_id
  aviatrix_azure_account                    = dependency.controller_config.outputs.aviatrix_azure_account
  allowed_public_ips                        = local.allowed_public_ips
  controller_public_ip                      = dependency.controller_deployment.outputs.controller_public_ip
  controller_username                       = dependency.controller_deployment.outputs.controller_admin_username
  controller_password                       = dependency.controller_deployment.outputs.controller_admin_password
}