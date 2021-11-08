# Initial Setup with create the Resource Group, Storage Account, and Storage Account Container for state files

module "initial_setup" {
  source = "github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/initial_setup?ref=features/addInitialAzureSetup"
  resource_prefix       = "travis-control"
  location              = "South Central US"
  user_principal_id     = var.user_principal_id
  aviatrix_customer_id  = var.aviatrix_customer_id
  azure_subscription_id = var.azure_subscription_id
  azure_tenant_id       = var.azure_tenant_id
  azure_application_id  = var.azure_application_id
  azure_application_key = var.azure_application_key
  aws_access_key        = var.aws_access_key
  aws_secret_key        = var.aws_secret_key
  aws_account_number    = var.aws_account_number
  gcp_project_id        = var.gcp_project_id
  gcp_secret_json       = var.gcp_secret_json
}