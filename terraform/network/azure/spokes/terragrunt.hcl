remote_state {
  backend "azurerm" {
    config = {
        resource_group_name  = "travis-control-rg"
        storage_account_name = "traviscontrolsa"
        container_name       = "tfstate"
        key                  = "${path_relative_to_include()}.terraform.tfstate"
        use_azuread_auth     = true
    }
  }
}