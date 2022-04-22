terraform {
  source = "${local.source_base_url}?ref=${local.source_version}"
}

locals {
  path_split            = split("/", get_terragrunt_dir())                                                                         # path_split: Separates directory into an array/
  environment           = element(local.path_split, length(local.path_split) - 5)
  region                = element(local.path_split, length(local.path_split) - 2)                                                  # region: This will take the region path to get the directory name for the region.
  transit_name          = element(local.path_split, length(local.path_split) - 1)
  global_vars           = yamldecode(file("${dirname(find_in_parent_folders())}/_common/global_vars.yaml"))
  network_vars          = yamldecode(file("${dirname(find_in_parent_folders())}/_common/networks.yaml"))
  source_version        = local.global_vars.source_code_version
  source_base_url       = "${local.global_vars.source_code_base_url}//modules/aws/transit"
  region_vars           = local.global_vars.aws.regions["${local.region}"]
  region_code           = local.region_vars.region_code
  aws_region_location   = local.region_vars.location

  allowed_public_ips    = local.network_vars.allowed_public_ips
  vpc_address_prefix   = local.network_vars["${local.environment}"]["aws"]["${local.region}"]["transit"]

  resource_prefix                = "travis-${local.region_code}-${local.transit_name}"
  resource_group_name            = "${local.resource_prefix}-rg"
  vpc_name                       = "${local.resource_prefix}-vpc"
  transit_subnet_name            = "${local.resource_prefix}-primary-subnet"
  transit_ha_subnet_name         = "${local.resource_prefix}-ha-subnet"
  firewall_mgmt_subnet_name      = "${local.resource_prefix}-fw-mgmt-subnet"
  firewall_mgmt_ha_subnet_name   = "${local.resource_prefix}-fw-mgmt-ha-subnet"
  firewall_egress_subnet_name    = "${local.resource_prefix}-fw-egress-subnet"
  firewall_egress_ha_subnet_name = "${local.resource_prefix}-fw-egress-ha-subnet"
  transit_gateway_name           = "${local.resource_prefix}-gw"
  firewall_name                  = "${local.resource_prefix}-fw"
  primary_access_account_name    = "${local.resource_prefix}-primary-account"
  s3_bucket_name                 = "${local.resource_prefix}-bootstrap-bucket"
  s3_iam_role_name               = "${local.resource_prefix}-bootstrap-s3-role"
}

dependency "controller_deployment" {
  config_path = "../../../../management/controller/deployment"
}

inputs = {
  controller_public_ip                         = dependency.controller_deployment.outputs.aviatrix_controller_public_ip
  controller_username                          = "admin"
  controller_password                          = dependency.controller_deployment.outputs.controller_admin_password
  aviatrix_access_account_name                 = dependency.controller_deployment.outputs.aviatrix_primary_account_name
  region                                       = local.aws_region_location
  vpc_name                                     = local.vpc_name
  vpc_address_space                            = local.vpc_address_prefix
  insane_mode                                  = true
  aviatrix_transit_primary_subnet_name         = local.transit_subnet_name
  aviatrix_transit_ha_subnet_name              = local.transit_ha_subnet_name
  aviatrix_firewall_mgmt_primary_subnet_name   = local.firewall_mgmt_subnet_name
  aviatrix_firewall_mgmt_ha_subnet_name        = local.firewall_mgmt_ha_subnet_name
  aviatrix_firewall_egress_primary_subnet_name = local.firewall_egress_subnet_name
  aviatrix_firewall_egress_ha_subnet_name      = local.firewall_egress_ha_subnet_name
  aviatrix_transit_availability_zone_1         = "${local.aws_region_location}a"
  aviatrix_transit_availability_zone_2         = "${local.aws_region_location}b"
  aviatrix_transit_gateway_name                = local.transit_gateway_name
  enable_aviatrix_transit_gateway_ha           = true
  enable_aviatrix_transit_firenet              = true
  aviatrix_transit_gateway_size                = "c5.xlarge" # insane mode & firenet
  firewall_allowed_ips                         = local.allowed_public_ips
  tag_prefix       = local.resource_prefix
  tags = {
    "CreatedBy" = "Terraform"
    "ownedBy"   = "${get_env("ADMIN_EMAIL")}"
  }
}