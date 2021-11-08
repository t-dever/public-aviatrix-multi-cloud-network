output "resource_group_name" {
  value       = module.initial_setup.resource_group_name
  description = "The resource group name"
}

output "key_vault_name" {
  value       = module.initial_setup.key_vault_name
  description = "The key vault name"
  sensitive   = true
}

output "key_vault_id" {
  value       = module.initial_setup.key_vault_id
  description = "The key vault ID"
  sensitive   = true
}

output "storage_account_id" {
  value       = module.initial_setup.storage_account_id
  description = "The storage account ID"
}

output "storage_account_name" {
  value       = module.initial_setup.storage_account_name
  description = "The storage account name"
}

output "log_analytics_workspace_id" {
  value       = module.initial_setup.log_analytics_workspace_id
  description = "The log analytics workspace id"
}

output "log_analytics_id" {
  value       = module.initial_setup.log_analytics_id
  description = "The log analytics id"
}

output "log_analytics_name" {
  value       = module.initial_setup.log_analytics_name
  description = "The log analytics name"
}
output "log_analytics_region" {
  value       = module.initial_setup.log_analytics_region
  description = "The log analytics region"
}
output "controller_admin_password" {
  value       = module.initial_setup.controller_admin_password
  description = "The controller admin password"
  sensitive   = true
}

output "azure_application_key" {
  value       = module.initial_setup.azure_application_key
  description = "The Application key for the service principal"
  sensitive   = true
}

output "aviatrix_customer_id" {
  value       = module.initial_setup.aviatrix_customer_id
  description = "The customer id used for the azure controller"
  sensitive   = true
}
