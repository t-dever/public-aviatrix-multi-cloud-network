variable "user_principal_id" {
  description = "The ID of the user that needs to access the key vault via Azure Portal GUI. This is used to give key vault secrets officer role"
}
variable "aviatrix_customer_id" {
  description = "The ID used for the aviatrix controller"
}
variable "azure_subscription_id" {
  description = "Azure Subscription ID"
}
variable "azure_tenant_id" {
  description = "Azure Tenant ID"
}
variable "azure_application_id" {
  description = "Azure App Registration ID"
}
variable "azure_application_key" {
  description = "Azure App Registration Secret/Key"
}
variable "aws_access_key" {
  description = "AWS Access Key"
}
variable "aws_secret_key" {
  description = "AWS Secret Key"
}
variable "aws_account_number" {
  description = "AWS Account Number"
}
variable "gcp_project_id" {
  description = "GCP Project ID"
}
variable "gcp_secret_json" {
  description = "JSON value for GCP Secrets"
}