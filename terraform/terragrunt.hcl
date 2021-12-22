# Recommendation, enable RBAC for azure storage account state file access
remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = get_env("REMOTE_STATE_RESOURCE_GROUP")
    storage_account_name = get_env("REMOTE_STATE_STORAGE_ACCOUNT")
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

