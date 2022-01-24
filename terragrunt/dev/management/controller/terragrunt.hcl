include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.base_source_url}?ref=v1.1.1"
}

locals {
  base_source_url = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/aviatrix_controller"
}

dependency "state" {
  config_path = "../state"
}

inputs = {
  location                           = "South Central US"
  resource_prefix                    = "travis-ussc-controller"
  vnet_address_prefix                = "10.0.0.0/16"
  controller_subnet_address_prefix   = "10.0.0.0/24"
  network_watcher_name               = "NetworkWatcher_southcentralus"
  controller_version                 = "UserConnect-6.5.2898"
  log_analytics_workspace_id         = dependency.state.outputs.log_analytics_workspace_id
  log_analytics_id                   = dependency.state.outputs.log_analytics_id
  log_analytics_location             = dependency.state.outputs.log_analytics_region
  key_vault_id                       = dependency.state.outputs.key_vault_id
  controller_user_public_ip_address  = get_env("USER_PUBLIC_IP_ADDRESS")
  build_agent_ip_address             = get_env("BUILD_AGENT_PUBLIC_IP_ADDRESS")
  controller_customer_id             = get_env("CONTROLLER_CUSTOMER_ID")
  azure_application_key              = get_env("ARM_CLIENT_SECRET")
  aviatrix_azure_access_account_name = get_env("AZURE_ACCESS_ACCOUNT")
  admin_email                        = get_env("ADMIN_EMAIL")
  controller_username                = get_env("AVIATRIX_CONTROLLER_USERNAME")
}