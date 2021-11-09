module "azure_aviatrix_controller" {
  source                             = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/aviatrix_controller?ref=v1.0.1"
  location                           = "South Central US"
  resource_prefix                    = "travis-ussc-controller"
  vnet_address_prefix                = "10.0.0.0/16"
  controller_subnet_address_prefix   = "10.0.0.0/24"
  network_watcher_name               = "NetworkWatcher_southcentralus"
  admin_email                        = "tdever@aviatrix.com"
  aviatrix_azure_access_account_name = "tdever-azure-account"
  controller_version                 = "UserConnect-6.5.2613"
  controller_user_public_ip_address  = var.user_public_ip_address
  build_agent_ip_address             = var.build_agent_ip_address
  log_analytics_workspace_id         = data.terraform_remote_state.initial_config.outputs.log_analytics_workspace_id
  log_analytics_id                   = data.terraform_remote_state.initial_config.outputs.log_analytics_id
  log_analytics_location             = data.terraform_remote_state.initial_config.outputs.log_analytics_region
  azure_application_key              = data.terraform_remote_state.initial_config.outputs.azure_application_key
  controller_admin_password          = data.terraform_remote_state.initial_config.outputs.controller_admin_password
  controller_customer_id             = data.terraform_remote_state.initial_config.outputs.aviatrix_customer_id
}
