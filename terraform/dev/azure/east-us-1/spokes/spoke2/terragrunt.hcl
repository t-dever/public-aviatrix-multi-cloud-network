include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/azure/spokes.hcl"
}

inputs = {
  resource_prefix                        = "travis-use1-spoke2"
  vnet_address_prefix                    = "10.1.4.0/23"
  gateway_subnet_address_prefix          = "10.1.5.0/24"
  virtual_machines_subnet_address_prefix = "10.1.6.0/24"
}