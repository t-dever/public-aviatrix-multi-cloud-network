include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.base_source_url}?ref=features/AllowFirewallInHub"
}

locals {
  base_source_url = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/aviatrix_controller/deployment"
}

dependency "state" {
  config_path = "../../state"
}

inputs = {
  location                         = "South Central US"
  resource_group_name              = "travis-management-rg"
  vnet_name                        = "travis-management-vnet"
  vnet_address_prefix              = "10.0.0.0/23"
  controller_subnet_address_prefix = "10.0.0.0/24"
  aviatrix_controller_name         = "travis-management-controller"
  controller_vm_size               = "Standard_A4_v2"
  # controller_version               = "UserConnect-6.5.2898"
  controller_version             = "UserConnect-6.6.5224"
  controller_customer_id         = get_env("CONTROLLER_CUSTOMER_ID")
  admin_email                    = get_env("ADMIN_EMAIL")
  deploy_copilot                 = true
  copilot_name                   = "travis-management-copilot"
  copilot_vm_size                = "Standard_D8as_v4"
  enable_scheduled_shutdown      = true
  enable_spot_instances          = true
  store_credentials_in_key_vault = true
  key_vault_id                   = dependency.state.outputs.key_vault_id
}