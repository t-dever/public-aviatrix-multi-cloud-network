remote_state {
  backend = "azurerm"
  config = {
      resource_group_name  = "travis-control-rg"
      storage_account_name = "traviscontrolsa"
      container_name       = "tfstate"
      subscription_id = "cb041d9e-984f-46a4-938d-572a08b8c176"
      tenant_id = "a063e36b-33b8-4031-964a-10e21b0b4d94"
      key                  = "${path_relative_to_include()}.terraform.tfstate"
      use_azuread_auth     = true
  }
}