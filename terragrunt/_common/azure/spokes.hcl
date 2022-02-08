terraform {
  source = "${local.base_source_url}?ref=${local.source_version}"
}

locals {
  base_source_url                        = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/spokes"
  global_vars                            = read_terragrunt_config("${dirname(find_in_parent_folders())}/_common/global_vars.hcl")
  source_version                         = local.global_vars.locals.source_version
  environment_vars                       = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment                            = local.environment_vars.locals.environment
  path_split                             = split("/", get_terragrunt_dir())
  region                                 = element(local.path_split, length(local.path_split) - 3)
  region_vars                            = read_terragrunt_config("${dirname(find_in_parent_folders())}/_common/azure/regions/${local.region}.hcl")
  azure_region_code                      = local.region_vars.locals.region
  spoke_name                             = element(local.path_split, length(local.path_split) - 1)
  region_code                            = local.region_vars.locals.region_code
  resource_prefix                        = "travis-${local.region_code}-${local.spoke_name}"
  storage_account_name                   = "${replace(local.resource_prefix, "-", "")}sa"
  resource_group_name                    = "${local.resource_prefix}-rg"
  vnet_name                              = "${local.resource_prefix}-vnet"
  spoke_gateway_name                     = "${local.resource_prefix}-gw"
  test_vm_name                           = "${local.resource_prefix}-test-vm"
  local_segmentation_domain              = "${local.resource_prefix}"
  network_vars                           = read_terragrunt_config("${dirname(find_in_parent_folders())}/_common/networks.hcl")
  spoke_folder_name                      = element(local.path_split, length(local.path_split) - 1)
  vnet_address_prefix                    = local.network_vars.locals["${local.environment}"]["azure"]["${local.region}"]["spokes"]["${local.spoke_folder_name}"]
  cidrbits                               = tonumber(split("/", local.vnet_address_prefix)[1])
  subnets                                = cidrsubnets(local.vnet_address_prefix, 24 - local.cidrbits, 24 - local.cidrbits)
  gateway_subnet_address_prefix          = local.subnets[0]
  virtual_machines_subnet_address_prefix = local.subnets[1]
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
  location                               = local.azure_region_code
  resource_group_name                    = local.resource_group_name
  storage_account_name                   = local.storage_account_name
  vnet_name                              = local.vnet_name
  vnet_address_prefix                    = local.vnet_address_prefix
  gateway_subnet_address_prefix          = local.gateway_subnet_address_prefix
  virtual_machines_subnet_address_prefix = local.virtual_machines_subnet_address_prefix
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