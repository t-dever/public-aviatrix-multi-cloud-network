include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.base_source_url}?ref=${local.source_version}"
}

locals {
  base_source_url    = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/initial_setup"
  global_vars        = yamldecode(file("${dirname(find_in_parent_folders())}/_common/global_vars.yaml"))
  source_version     = local.global_vars.source_code_version
  network_vars       = local.global_vars.network_vars
  allowed_public_ips = local.network_vars.allowed_public_ips
}

inputs = {
  resource_prefix          = "travis-control"
  location                 = "South Central US"
  user_principal_id        = get_env("USER_PRINCIPAL_ID")
  azure_subscription_id    = get_env("ARM_SUBSCRIPTION_ID")
  azure_tenant_id          = get_env("ARM_TENANT_ID")
  azure_application_id     = get_env("ARM_CLIENT_ID")
  azure_application_key    = get_env("ARM_CLIENT_SECRET")
  allowed_public_ips       = local.allowed_public_ips
  generate_private_ssh_key = false
}
