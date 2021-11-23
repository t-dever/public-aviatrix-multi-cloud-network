locals {
  environment                      = "dev"
  controller_username              = get_env("AVIATRIX_CONTROLLER_USERNAME")
  controller_public_ip             = get_env("AVIATRIX_CONTROLLER_IP")
  controller_password              = get_env("AVIATRIX_CONTROLLER_PASSWORD")
  aviatrix_azure_account           = get_env("AVIATRIX_ACCESS_ACCOUNT")
  key_vault_id                     = get_env("KEY_VAULT_ID")
  user_public_for_mgmt             = get_env("USER_PUBLIC_IP")
}