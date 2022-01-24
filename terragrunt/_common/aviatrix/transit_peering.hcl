terraform {
  source = "${local.base_source_url}"
}

locals {
  base_source_url = "${dirname(find_in_parent_folders())}/_common/modules//transit_peering"
}