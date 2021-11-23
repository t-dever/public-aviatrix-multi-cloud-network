include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/common/spokes.hcl"
}

inputs = {
  resource_prefix                        = "travis-ussc-spoke1"
  location                               = "South Central US"
  aviatrix_azure_account                 = data.terraform_remote_state.controller.outputs.aviatrix_azure_account
  vnet_address_prefix                    = "10.0.2.0/23"
  gateway_subnet_address_prefix          = "10.0.2.0/24"
  virtual_machines_subnet_address_prefix = "10.0.3.0/24"
  controller_public_ip                   = data.terraform_remote_state.controller.outputs.controller_public_ip
  controller_admin_password              = data.terraform_remote_state.initial_config.outputs.controller_admin_password
  key_vault_id                           = data.terraform_remote_state.initial_config.outputs.key_vault_id
}