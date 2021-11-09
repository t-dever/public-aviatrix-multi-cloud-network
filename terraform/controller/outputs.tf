output "user_public_ip_address" {
    description = "The user public ip address that will be accessing the controller"
    value = var.user_public_ip_address
    sensitive = true
}

output "controller_public_ip" {
  value       = module.azure_aviatrix_controller.controller_public_ip
  description = "The IP Address of the Aviatrix Controller"
  sensitive = true
}

output "aviatrix_azure_account" {
  value       = module.azure_aviatrix_controller.aviatrix_azure_account
  description = "The Azure account provisioned in the aviatrix controller used for accessing subscriptions"
  sensitive = true
}