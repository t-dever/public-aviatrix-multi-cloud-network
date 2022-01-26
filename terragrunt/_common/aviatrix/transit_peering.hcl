terraform {
  source = "${local.base_source_url}"
}

dependency "controller_deployment" {
  config_path = "../../management/controller/deployment"
}


locals {
  base_source_url = "${dirname(find_in_parent_folders())}/_common/modules//transit_peering"
}

inputs = {
  controller_public_ip = dependency.controller_deployment.outputs.controller_public_ip
  controller_username  = "admin"
  controller_password  = dependency.controller_deployment.outputs.controller_admin_password
}