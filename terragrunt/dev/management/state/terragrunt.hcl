include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.base_source_url}?ref=v2.0.4"
}

locals {
  base_source_url = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/initial_setup"
}

inputs = {
  resource_prefix          = "travis-control"
  allowed_public_ips       = ["209.169.92.39"]
  generate_private_ssh_key = false
  user_principal_id        = get_env("USER_PRINCIPAL_ID")
}