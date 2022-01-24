include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.base_source_url}?ref=addFortinetToHubModule"
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
  controller_version               = "UserConnect-6.5.2898"
  admin_email                      = get_env("ADMIN_EMAIL")
  deploy_copilot                   = true
  copilot_name                     = "travis-management-copilot"
  copilot_vm_size                  = "Standard_D8as_v4"
  enable_scheduled_shutdown        = true
  enable_spot_instances            = true
  store_credentials_in_key_vault   = true
  key_vault_id                     = dependency.state.outputs.key_vault_id

  #   controller_user_public_ip_address  = get_env("USER_PUBLIC_IP_ADDRESS")
  #   build_agent_ip_address             = get_env("BUILD_AGENT_PUBLIC_IP_ADDRESS")
  #   controller_customer_id             = get_env("CONTROLLER_CUSTOMER_ID")
  #   azure_application_key              = get_env("ARM_CLIENT_SECRET")
  #   aviatrix_azure_access_account_name = get_env("AZURE_ACCESS_ACCOUNT")
  #   controller_username                = get_env("AVIATRIX_CONTROLLER_USERNAME")
}