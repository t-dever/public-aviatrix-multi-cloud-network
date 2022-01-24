include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/azure/transits.hcl"
}

inputs = {
  vnet_address_prefix = "10.0.0.0/23"
  firewall_count      = 3
}

# resource_group_name                       = "travis-ussc-transit-rg"
# vnet_name                                 = "travis-ussc-hub-vnet"
# transit_gateway_name                      = "travis-ussc-transit-gw"
# transit_gateway_ha                        = true
# enable_transit_gateway_scheduled_shutdown = true
# insane_mode                               = false
# firenet_enabled                           = true
# firewall_name                             = "travis-ussc-transit-fw"
# egress_enabled                            = true
# firewall_image                            = "Fortinet FortiGate (PAYG_20190624) Next-Generation Firewall Latest Release"
# firewall_image_version                    = "7.0.3"
# firewall_count = 2