terraform {
  source = "${local.source_base_url}?ref=${local.source_version}"
}

locals {
  global_vars        = yamldecode(file("${dirname(find_in_parent_folders())}/_common/global_vars.yaml"))
  source_version     = local.global_vars.source_code_version
  source_base_url    = "${local.global_vars.source_code_base_url}//modules/azure/aviatrix_controller"
  network_vars       = yamldecode(file("${dirname(find_in_parent_folders())}/_common/networks.yaml"))
  allowed_public_ips = local.network_vars.allowed_public_ips
}

inputs = {
  location                                     = "South Central US"
  resource_group_name                          = "travis-management-rg"
  vnet_name                                    = "travis-management-vnet"
  vnet_address_prefix                          = "10.0.0.0/23"
  controller_subnet_address_prefix             = "10.0.0.0/24"
  aviatrix_controller_name                     = "travis-management-controller"
  aviatrix_controller_username                 = "admin"
  aviatrix_controller_instance_size            = "Standard_D4_v5"
  aviatrix_controller_version                  = "7.1"
  aviatrix_controller_customer_id              = get_env("CONTROLLER_CUSTOMER_ID")
  aviatrix_controller_admin_email              = get_env("ADMIN_EMAIL")
  allowed_ips                                  = local.allowed_public_ips
  aviatrix_deploy_copilot                      = true
  aviatrix_copilot_name                        = "travis-management-copilot"
  aviatrix_copilot_instance_size               = "Standard_D8as_v4"
  enable_scheduled_shutdown                    = true
  enable_spot_instances                        = false
  store_credentials_in_key_vault               = true
  aviatrix_enable_security_group_management = true
  aviatrix_azure_primary_account_name          = "travis-azure-primary-account"
  aviatrix_azure_primary_account_client_secret = get_env("ARM_CLIENT_SECRET")
  aviatrix_controller_public_ssh_key           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3e8QwCWEfjbI0VeuqzAfB2YQYlA4uZK70MfUG2kd1AadMs0jJMIurvzpKMgC3hSvIb9s0hGsGLPv7REO+TCtNXS+vhaHkQxVFGnIHTW60IiuFACeDKpJpJXV9VTOATSA5eTHb0rW5nX/x1wCc/JVTeDKaJC/4Qa3sETdinCjX3qmd88AdzXNVJ9p+aPAx1PvJ6qFjyxOdG/GSSQKyhGLzfY2O2c3cWL/eYqkA5Fj6x4PCQMQehmdSJyopCmhISx+GI7lNyf8ovUhekJhBZ+a7wEQcZWOCcdNxkOJN5+ucrgz+m08oq5JWSYyCFtkRrMMVRHIJO3gpXVQ9iWrzVEZiEZS4JyHoGBK8Y1DF4ubIQzhDXdSI8yXTXzGLJcrDsWTscRStR/E/mqhJLT2Dj/1/zs7p6Q0pVR1FNQanL2jgWGjL6ZueSsQYH2j8XF7RzWbjLcH/Bs/xob0zKrJ6m3TSyfMDB2C5ZSHtdVtTWxKDSdifqSws9s8j/2ngaO6KQThH6o0D6H4QXeIHmX6vnn2uUNl0aiPTwrqawT2mt7vlelVMd4MPhitzmQCt5vZ4Mg8AbW4GVjM5x5ToIyxnT10jZJSeERefIrD5AV/c4Sd/MPibw7/6zXYKeARnsOpImdRKMii3jxBYV3E4XyMdXvgXnNqHbMyX74sRMSy0pgKMjw== travis dever@TravisDever-Laptop"
  aviatrix_copilot_public_ssh_key              = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3e8QwCWEfjbI0VeuqzAfB2YQYlA4uZK70MfUG2kd1AadMs0jJMIurvzpKMgC3hSvIb9s0hGsGLPv7REO+TCtNXS+vhaHkQxVFGnIHTW60IiuFACeDKpJpJXV9VTOATSA5eTHb0rW5nX/x1wCc/JVTeDKaJC/4Qa3sETdinCjX3qmd88AdzXNVJ9p+aPAx1PvJ6qFjyxOdG/GSSQKyhGLzfY2O2c3cWL/eYqkA5Fj6x4PCQMQehmdSJyopCmhISx+GI7lNyf8ovUhekJhBZ+a7wEQcZWOCcdNxkOJN5+ucrgz+m08oq5JWSYyCFtkRrMMVRHIJO3gpXVQ9iWrzVEZiEZS4JyHoGBK8Y1DF4ubIQzhDXdSI8yXTXzGLJcrDsWTscRStR/E/mqhJLT2Dj/1/zs7p6Q0pVR1FNQanL2jgWGjL6ZueSsQYH2j8XF7RzWbjLcH/Bs/xob0zKrJ6m3TSyfMDB2C5ZSHtdVtTWxKDSdifqSws9s8j/2ngaO6KQThH6o0D6H4QXeIHmX6vnn2uUNl0aiPTwrqawT2mt7vlelVMd4MPhitzmQCt5vZ4Mg8AbW4GVjM5x5ToIyxnT10jZJSeERefIrD5AV/c4Sd/MPibw7/6zXYKeARnsOpImdRKMii3jxBYV3E4XyMdXvgXnNqHbMyX74sRMSy0pgKMjw== travis dever@TravisDever-Laptop"
}