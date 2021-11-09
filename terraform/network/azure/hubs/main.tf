module "azure_ussc_hub" {
  source                             = "git@github.com:t-dever/reusable-aviatrix-terraform-modules.git//modules/azure/azure_hub"
  resource_prefix                    = "travis-ussc-hub"
  location                           = "South Central US"
  aviatrix_azure_account             = "tdever-azure-account"
  vnet_address_prefix                = "10.0.0.0/23"
  gateway_mgmt_subnet_address_prefix = "10.0.0.0/28"
  firewall_ingress_egress_prefix     = "10.0.0.16/28"
  network_watcher_name               = "NetworkWatcher_southcentralus"
  controller_public_ip               = data.terraform_remote_state.controller.outputs.controller_public_ip
  controller_admin_password          = data.terraform_remote_state.initial_config.outputs.controller_admin_password
  user_public_for_mgmt               = data.terraform_remote_state.controller.outputs.user_public_ip_address
  key_vault_id                       = data.terraform_remote_state.initial_config.outputs.key_vault_id
  log_analytics_workspace_id         = data.terraform_remote_state.initial_config.outputs.log_analytics_workspace_id
  log_analytics_id                   = data.terraform_remote_state.initial_config.outputs.log_analytics_id
  log_analytics_location             = data.terraform_remote_state.initial_config.outputs.log_analytics_region
}