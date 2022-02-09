include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/azure/spokes.hcl"
}

inputs = {
  insane_mode = false
}