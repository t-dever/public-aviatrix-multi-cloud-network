include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/azure/spokes.hcl"
}

inputs = {
  resource_prefix                        = "travis-ussc-spoke1"
  vnet_address_prefix                    = "10.0.2.0/23"
  gateway_subnet_address_prefix          = "10.0.2.0/24"
  virtual_machines_subnet_address_prefix = "10.0.3.0/24"
}