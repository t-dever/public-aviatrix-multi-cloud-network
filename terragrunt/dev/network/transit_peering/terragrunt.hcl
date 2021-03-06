include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/aviatrix/transit_peering.hcl"
}

dependency "ussc_transit" {
  config_path = "../azure/south-central-us/transit"
}

dependency "use1_transit" {
  config_path = "../azure/east-us-1/transit"
}

dependencies {
  paths = [
    "../azure/south-central-us/transit",
    "../azure/east-us-1/transit"
  ]
}

inputs = {
  transit_gateway_peerings = [
    {
      transit_gateway_1 = dependency.ussc_transit.outputs.transit_gateway_name
      transit_gateway_2 = dependency.use1_transit.outputs.transit_gateway_name
    }
  ]
}
