terraform {
  backend "azurerm" {
    key                  = "azure.hubs.state"
    use_azuread_auth     = true
  }
}

data "terraform_remote_state" "initial_config" {
  backend = "azurerm"
  config = {
    storage_account_name = var.state_storage_account_name
    container_name       = "tfstate"
    key                  = "initial.config.state"
    use_azuread_auth     = true
  }
}

data "terraform_remote_state" "controller" {
  backend = "azurerm"
  config = {
    storage_account_name = var.state_storage_account_name
    container_name       = "tfstate"
    key                  = "controller.deployment.state"
    use_azuread_auth     = true
  }
}