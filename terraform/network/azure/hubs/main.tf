module "azure_ussc_hub" {
  source                             = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/hub?ref=features/addHubs"
  resource_prefix                    = "travis-ussc-hub"
  location                           = "South Central US"
  aviatrix_azure_account             = data.terraform_remote_state.controller.outputs.aviatrix_azure_account
  vnet_address_prefix                = "10.0.0.0/23"
  gateway_mgmt_subnet_address_prefix = "10.0.0.0/28"
  firewall_ingress_egress_prefix     = "10.0.0.16/28"
  controller_public_ip               = data.terraform_remote_state.controller.outputs.controller_public_ip
  controller_admin_password          = data.terraform_remote_state.initial_config.outputs.controller_admin_password
  user_public_for_mgmt               = data.terraform_remote_state.controller.outputs.user_public_ip_address
  key_vault_id                       = data.terraform_remote_state.initial_config.outputs.key_vault_id
  firenet_enabled                    = false
}
