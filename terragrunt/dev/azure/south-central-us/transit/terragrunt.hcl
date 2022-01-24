include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/azure/transits.hcl"
}

inputs = {
  vnet_address_prefix = "10.0.0.0/23"
}