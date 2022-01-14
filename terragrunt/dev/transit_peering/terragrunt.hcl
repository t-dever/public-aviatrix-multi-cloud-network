include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/peerings/transit_peering.hcl"
}

dependency "ussc_transit" {
  config_path = "../azure/south-central-us/hub"
}

dependency "use1_transit" {
  config_path = "../azure/east-us-1/hub"
}

inputs = {
  transit_gateway_peerings = [
    {
      transit_gateway_1 = dependency.ussc_transit.outputs.transit_gateway_name
      transit_gateway_2 = dependency.use1_transit.outputs.transit_gateway_name
    }
  ]
}
