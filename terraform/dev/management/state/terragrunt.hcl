include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.base_source_url}?ref=main"
}

locals {
  base_source_url = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/initial_setup"
}

inputs = {
  resource_prefix                    = "travis-control"
  location                           = "South Central US"
  user_principal_id                  = get_env("USER_PRINCIPAL_ID")
  azure_subscription_id              = get_env("ARM_SUBSCRIPTION_ID")
  azure_tenant_id                    = get_env("ARM_TENANT_ID")
  azure_application_id               = get_env("ARM_CLIENT_ID")
  azure_application_key              = get_env("ARM_CLIENT_SECRET")
}