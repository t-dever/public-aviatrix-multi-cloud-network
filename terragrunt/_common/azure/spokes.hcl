terraform {
  # source = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/spokes?ref=${local.source_version}"
  source = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/spokes?ref=testing/privateAndPublicSubnets"
}

locals {
  global_vars                            = yamldecode(file("${dirname(find_in_parent_folders())}/_common/global_vars.yaml"))
  source_version                         = local.global_vars.source_code_version

  path_split                             = split("/", get_terragrunt_dir())                                                                         # path_split: Separates directory into an array/
  environment_folder_name                = element(local.path_split, length(local.path_split) - 6)
  cloud_provider_folder_name             = element(local.path_split, length(local.path_split) - 4)
  region_folder_name                     = element(local.path_split, length(local.path_split) - 3)                                                  # region: This will take the region path to get the directory name for the region.
  spoke_folder_name                      = element(local.path_split, length(local.path_split) - 1)

  region_vars                            = local.global_vars.cloud_vars["${local.cloud_provider_folder_name}"].regions["${local.region_folder_name}"]
  network_vars                           = local.global_vars.network_vars["${local.environment_folder_name}"]["${local.cloud_provider_folder_name}"]["${local.region_folder_name}"].spokes["${local.spoke_folder_name}"]
  environment_vars                       = local.global_vars.environment_vars["${local.environment_folder_name}"]
  allowed_public_ips                     = local.global_vars.network_vars.allowed_public_ips

  region_code                            = local.region_vars.region_code
  azure_region_location                  = local.region_vars.location

  aviatrix_vnet_address_prefix           = local.network_vars.private_network
  user_vnet_address_prefix               = local.network_vars.public_network

  # cidrbits                               = tonumber(split("/", local.aviatrix_vnet_address_prefix)[1])
  # subnets                                = cidrsubnets(local.vnet_address_prefix, 24 - local.cidrbits, 24 - local.cidrbits)
  # gateway_subnet_address_prefix          = local.subnets[0]
  # virtual_machines_subnet_address_prefix = local.subnets[1]

  resource_prefix                        = "travis-${local.region_code}-${local.spoke_folder_name}"
  storage_account_name                   = "${replace(local.resource_prefix, "-", "")}sa"
  resource_group_name                    = "${local.resource_prefix}-rg"
  vnet_name                              = "${local.resource_prefix}-vnet"
  spoke_gateway_name                     = "${local.resource_prefix}-gw"
  test_vm_name                           = "${local.resource_prefix}-test-vm"
  local_segmentation_domain              = "${local.resource_prefix}"
}

dependency "state" {
  config_path = "../../../../../management/state"
}

dependency "controller_deployment" {
  config_path = "../../../../../management/controller/deployment"
}

dependency "controller_config" {
  config_path = "../../../../../management/controller/config"
}

dependency "transit" {
  config_path = "../../transit"
}

inputs = {
  location                               = local.azure_region_location
  resource_group_name                    = local.resource_group_name
  storage_account_name                   = local.storage_account_name
  vnet_name                              = local.vnet_name
  aviatrix_vnet_address_prefix           = local.aviatrix_vnet_address_prefix
  user_vnet_address_prefix               = local.user_vnet_address_prefix
  # gateway_subnet_address_prefix          = local.gateway_subnet_address_prefix
  # virtual_machines_subnet_address_prefix = local.virtual_machines_subnet_address_prefix
  spoke_gateway_name                     = local.spoke_gateway_name
  test_vm_name                           = local.test_vm_name
  spoke_gw_size                          = "Standard_B1ms"
  spoke_gateway_ha                       = true
  firenet_inspection                     = false
  insane_mode                            = false
  aviatrix_azure_account                 = dependency.controller_config.outputs.aviatrix_azure_account
  key_vault_id                           = dependency.state.outputs.key_vault_id
  transit_gateway_name                   = dependency.transit.outputs.transit_gateway_name
  firenet_inspection                     = dependency.transit.outputs.firenet_enabled
  segmentation_domain_name               = local.local_segmentation_domain
  controller_public_ip                   = dependency.controller_deployment.outputs.controller_public_ip
  controller_username                    = dependency.controller_deployment.outputs.controller_admin_username
  controller_password                    = dependency.controller_deployment.outputs.controller_admin_password
}