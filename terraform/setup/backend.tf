terraform {
  backend "azurerm" {
    key                  = "initial.config.state"
    use_azuread_auth     = true
  }
}