include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.base_source_url}?ref=v2.0.4"
}

locals {
  base_source_url = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/aviatrix_controller/configuration"
}

dependency "deployment" {
  config_path = "../deployment"
}

dependency "state" {
  config_path = "../../state"
}

inputs = {
  azure_account_name               = "travis-azure-account"
  client_secret                    = get_env("ARM_CLIENT_SECRET")
  controller_public_ip             = dependency.deployment.outputs.controller_public_ip
  controller_private_ip            = dependency.deployment.outputs.controller_private_ip
  controller_username              = "admin"
  controller_password              = dependency.deployment.outputs.controller_admin_password
  copilot_public_ip                = dependency.deployment.outputs.copilot_public_ip
  copilot_private_ip               = dependency.deployment.outputs.copilot_private_ip
  resource_group_name              = dependency.deployment.outputs.resource_group_name
  resource_group_location          = dependency.deployment.outputs.resource_group_location
  allowed_public_ips               = ["209.169.92.39"]
  controller_subnet_id             = dependency.deployment.outputs.controller_subnet_id
  enable_security_group_management = true
  enable_netflow_to_copilot        = true
  netflow_port                     = "31283"
  enable_rsyslog_to_copilot        = true
  rsyslog_port                     = "5000"
  rsyslog_protocol                 = "UDP"
  enable_backup                    = true
  backup_storage_name              = dependency.state.outputs.storage_account_backup_name
  backup_container_name            = dependency.state.outputs.storage_account_backup_container_name
  backup_region                    = "South Central US"
}