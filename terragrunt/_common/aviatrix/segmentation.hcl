terraform {
  source = "${local.base_source_url}"
}

locals {
  base_source_url  = "${dirname(find_in_parent_folders())}/_common/modules//segmentation"
}

dependency "controller_deployment" {
  config_path = "../../management/controller/deployment"
}

inputs = {
  controller_public_ip     = dependency.controller_deployment.outputs.controller_public_ip
  controller_username      = dependency.controller_deployment.outputs.controller_admin_username
  controller_password      = dependency.controller_deployment.outputs.controller_admin_password
}