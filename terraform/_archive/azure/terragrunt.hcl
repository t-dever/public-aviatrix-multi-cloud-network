# These are your global variables
locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

# Recommendation, enable RBAC for azure storage account state file access
remote_state {
  backend = "azurerm"
  config = {
      resource_group_name  = "travis-control-rg"
      storage_account_name = "traviscontrolsa"
      container_name       = "tfstate"
      key                  = "${path_relative_to_include()}.terraform.tfstate"
      use_azuread_auth     = true
  }
}

# Generating this default "backend" is required but it's not actually used.
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "azurerm" {}
}
EOF
}

# This is merging all the inputs for your modules
inputs = merge(
  local.region_vars.locals,
  local.environment_vars.locals
)