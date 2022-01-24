terraform {
  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = "2.21.0-6.6.ga"
    }
  }
}

resource "aviatrix_transit_gateway_peering" "transit_gateway_peering" {
  for_each               = {for i, v in var.transit_gateway_peerings:  i => v}
  transit_gateway_name1  = each.value.transit_gateway_1
  transit_gateway_name2  = each.value.transit_gateway_2
}