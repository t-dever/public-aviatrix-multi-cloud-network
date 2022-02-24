include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/aviatrix/segmentation.hcl"
}


dependency "ussc_spoke1" {
  config_path = "../azure/south_central_us/spokes/spoke1"
}

dependency "use1_spoke1" {
  config_path = "../azure/east_us_1/spokes/spoke1"
}

dependency "use1_spoke2" {
  config_path = "../azure/east_us_1/spokes/spoke2"
}

dependencies {
  paths = [
    "../azure/south_central_us/spokes/spoke1",
    "../azure/east_us_1/spokes/spoke1",
    "../azure/east_us_1/spokes/spoke2",
  ]
}

inputs = {
  segmentation_domain_connection_policies = [
    { # South Central US spoke1 to East US 1 spoke1
      domain1 = dependency.ussc_spoke1.outputs.spoke_segmentation_domain_name
      domain2 = dependency.use1_spoke1.outputs.spoke_segmentation_domain_name
    },
    { # South Central US spoke1 to East US 1 spoke2
      domain1 = dependency.ussc_spoke1.outputs.spoke_segmentation_domain_name
      domain2 = dependency.use1_spoke2.outputs.spoke_segmentation_domain_name
    },
    { # East US 1 spoke 1 to East US 1 spoke 2
      domain1 = dependency.use1_spoke1.outputs.spoke_segmentation_domain_name
      domain2 = dependency.use1_spoke2.outputs.spoke_segmentation_domain_name
    }
  ]
}
