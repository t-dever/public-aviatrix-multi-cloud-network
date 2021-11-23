variable "state_storage_account_name" {
  description = "The storage account name used for the state configurations to reference previous state files."
}
variable "user_public_ip_address" {
  description = "The users public IP Address to access the controller."
  sensitive   = true
}
variable "build_agent_ip_address" {
  description = "The Public IP Address of the build agent to add to the NSG allow rule"
  sensitive   = true
}
