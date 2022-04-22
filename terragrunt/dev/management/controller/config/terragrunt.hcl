include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.base_source_url}?ref=${local.source_version}"
}

locals {
  base_source_url    = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/aviatrix/controller_config"
  global_vars        = yamldecode(file("${dirname(find_in_parent_folders())}/_common/global_vars.yaml"))
  source_version     = local.global_vars.source_code_version
}

dependency "state" {
  config_path = "../../state"
}

dependency "deployment" {
  config_path = "../deployment"
}

inputs = {
  controller_public_ip             = dependency.deployment.outputs.controller_public_ip
  controller_username              = dependency.deployment.outputs.controller_admin_username
  controller_password              = dependency.deployment.outputs.controller_admin_password
  aviatrix_access_account_name     = dependency.deployment.outputs.aviatrix_primary_access_account
  copilot_ip_address               = dependency.deployment.outputs.copilot_public_ip
  enable_security_group_management = true
  enable_rsyslog_to_copilot        = true
  enable_netflow_to_copilot        = true
  enable_backup                    = true
  enable_azure_backup              = {
                                        backup_account_name   = dependency.deployment.outputs.aviatrix_primary_access_account,
                                        backup_storage_name   = dependency.state.outputs.storage_account_backup_name,
                                        backup_container_name = dependency.state.outputs.storage_account_backup_container_name,
                                        backup_region         = "South Central US"
                                     }
}