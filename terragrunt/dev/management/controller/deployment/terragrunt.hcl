include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/azure/controller_deploy.hcl"
}

inputs = {
  location                         = "South Central US"
  resource_group_name              = "travis-management-rg"
  vnet_name                        = "travis-management-vnet"
  vnet_address_prefix              = "10.0.0.0/23"
  controller_subnet_address_prefix = "10.0.0.0/24"
  aviatrix_controller_name         = "travis-management-controller"
  aviatrix_controller_username     = "admin"
  copilot_name                     = "travis-management-copilot"
  aviatrix_deploy_copilot          = false
  store_credentials_in_key_vault   = false
  allowed_ips                      = ["<your public ip here>"]
  ssh_public_key                   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3e8QwCWEfjbI0VeuqzAfB2YQYlA4uZK70MfUG2kd1AadMs0jJMIurvzpKMgC3hSvIb9s0hGsGLPv7REO+TCtNXS+vhaHkQxVFGnIHTW60IiuFACeDKpJpJXV9VTOATSA5eTHb0rW5nX/x1wCc/JVTeDKaJC/4Qa3sETdinCjX3qmd88AdzXNVJ9p+aPAx1PvJ6qFjyxOdG/GSSQKyhGLzfY2O2c3cWL/eYqkA5Fj6x4PCQMQehmdSJyopCmhISx+GI7lNyf8ovUhekJhBZ+a7wEQcZWOCcdNxkOJN5+ucrgz+m08oq5JWSYyCFtkRrMMVRHIJO3gpXVQ9iWrzVEZiEZS4JyHoGBK8Y1DF4ubIQzhDXdSI8yXTXzGLJcrDsWTscRStR/E/mqhJLT2Dj/1/zs7p6Q0pVR1FNQanL2jgWGjL6ZueSsQYH2j8XF7RzWbjLcH/Bs/xob0zKrJ6m3TSyfMDB2C5ZSHtdVtTWxKDSdifqSws9s8j/2ngaO6KQThH6o0D6H4QXeIHmX6vnn2uUNl0aiPTwrqawT2mt7vlelVMd4MPhitzmQCt5vZ4Mg8AbW4GVjM5x5ToIyxnT10jZJSeERefIrD5AV/c4Sd/MPibw7/6zXYKeARnsOpImdRKMii3jxBYV3E4XyMdXvgXnNqHbMyX74sRMSy0pgKMjw== travis dever@TravisDever-Laptop"
  # aviatrix_controller_marketplace_image = {
  #   name      = "aviatrix-enterprise-bundle-byol"
  #   publisher = "aviatrix-systems"
  #   product   = "aviatrix-bundle-payg"
  # }
}
