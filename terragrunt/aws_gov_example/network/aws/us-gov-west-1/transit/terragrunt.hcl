include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/aws/transits.hcl"
}

inputs = {
  tag_prefix              = "travis-aviatrix-gov"
  firewall_image          = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
  firewall_image_version  = "10.1.4"
  firewalls = [
    {
      name = "travis-palo-1",
      size = "m5.xlarge"
    }
    # {
    #   name = "travis-palo-2",
    #   size = "m5.xlarge"
    # }
  ]
}