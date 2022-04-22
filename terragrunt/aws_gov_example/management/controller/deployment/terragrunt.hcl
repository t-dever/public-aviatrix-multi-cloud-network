include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/aws/controller.hcl"
}

inputs = {
  deploy_aviatrix_copilot = false
  enable_auto_aviatrix_copilot_security_group = false
}