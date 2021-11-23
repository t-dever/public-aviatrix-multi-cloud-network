include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/azure/hub.hcl"
}

inputs = {
  resource_prefix                    = "travis-ussc-hub"
  vnet_address_prefix                = "10.0.0.0/23"
  gateway_mgmt_subnet_address_prefix = "10.0.0.0/28"
  firewall_ingress_egress_prefix     = "10.0.0.16/28"
  firenet_enabled                    = false
}