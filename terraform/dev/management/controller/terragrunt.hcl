include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/management/controller.hcl"
}

inputs = {
  location                           = "South Central US"
  resource_prefix                    = "travis-ussc-controller"
  vnet_address_prefix                = "10.0.0.0/16"
  controller_subnet_address_prefix   = "10.0.0.0/24"
  network_watcher_name               = "NetworkWatcher_southcentralus"
  admin_email                        = "tdever@aviatrix.com"
  controller_version                 = "UserConnect-6.5.2721"
}