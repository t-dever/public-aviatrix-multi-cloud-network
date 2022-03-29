include "root" {
  path = find_in_parent_folders()
}

terraform {
  # source = "${local.base_source_url}?ref=${local.source_version}"
  source = "${local.base_source_url}?ref=hotfix/AllowAviatrixCredsthruvars"
}

locals {
  base_source_url    = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/aviatrix_controller/configuration"
  global_vars        = yamldecode(file("${dirname(find_in_parent_folders())}/_common/global_vars.yaml"))
  source_version     = local.global_vars.source_code_version
  network_vars       = yamldecode(file("${dirname(find_in_parent_folders())}/_common/networks.yaml"))
  allowed_public_ips = local.network_vars.allowed_public_ips
}

dependency "state" {
  config_path = "../../state"
}

dependency "deployment" {
  config_path = "../deployment"
}

inputs = {
  azure_account_name               = "travis-azure-account"
  client_secret                    = get_env("ARM_CLIENT_SECRET")
  controller_public_ip             = dependency.deployment.outputs.controller_public_ip
  controller_private_ip            = dependency.deployment.outputs.controller_private_ip
  controller_nic_id                = dependency.deployment.outputs.controller_nic_id
  controller_username              = dependency.deployment.outputs.controller_admin_username
  controller_password              = dependency.deployment.outputs.controller_admin_password
  copilot_public_ip                = dependency.deployment.outputs.copilot_public_ip
  copilot_private_ip               = dependency.deployment.outputs.copilot_private_ip
  resource_group_name              = dependency.deployment.outputs.resource_group_name
  allowed_public_ips               = local.allowed_public_ips
  controller_subnet_id             = dependency.deployment.outputs.controller_subnet_id
  enable_security_group_management = true
  enable_rsyslog_to_copilot        = true
  enable_netflow_to_copilot        = true
  enable_backup                    = true
  backup_storage_name              = dependency.state.outputs.storage_account_backup_name
  backup_container_name            = dependency.state.outputs.storage_account_backup_container_name
  backup_region                    = "South Central US"
}