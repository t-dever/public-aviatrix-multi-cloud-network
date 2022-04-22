terraform {
  source = "${local.source_base_url}?ref=${local.source_version}"
}

locals {
  path_split                             = split("/", get_terragrunt_dir())
  environment                            = element(local.path_split, length(local.path_split) - 4)
  global_vars                            = yamldecode(file("${dirname(find_in_parent_folders())}/_common/global_vars.yaml"))
  network_vars                           = yamldecode(file("${dirname(find_in_parent_folders())}/_common/networks.yaml"))
  source_version                         = local.global_vars.source_code_version
  source_base_url                        = "${local.global_vars.source_code_base_url}//modules/aws/aviatrix_controller"
  environment_vars                       = local.global_vars["environments"]["${local.environment}"]
  region                                 = local.environment_vars["region"]
  vpc_address_prefix                     = local.network_vars["${local.environment}"]["aws"]["controller"]
  cidrbits                               = tonumber(split("/", local.vpc_address_prefix)[1])
  subnets                                = cidrsubnets(local.vpc_address_prefix, 26 - local.cidrbits, 26 - local.cidrbits)
  controller_subnet_address_prefix       = local.subnets[0]
  copilot_subnet_address_prefix          = local.subnets[1]
  allowed_public_ips                     = local.network_vars.allowed_public_ips
  tag_prefix = "travis-usgovwest1"
}

inputs = {
    tag_prefix                                    = local.tag_prefix
    aws_region                                    = local.region
    aws_vpc_address_space                         = local.vpc_address_prefix
    aws_store_credentials_in_ssm                  = true
    aws_copilot_deploy                             = true
    aws_controller_subnet                         = {
      name = "${local.tag_prefix}-controller-subnet"
      cidr_block = "10.0.0.0/27"
      availability_zone = "${local.region}a"
    }
    aws_copilot_subnet                         = {
      name = "${local.tag_prefix}-copilot-subnet"
      cidr_block = "10.0.0.32/27"
      availability_zone = "${local.region}b"
    }
    aws_key_pair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3e8QwCWEfjbI0VeuqzAfB2YQYlA4uZK70MfUG2kd1AadMs0jJMIurvzpKMgC3hSvIb9s0hGsGLPv7REO+TCtNXS+vhaHkQxVFGnIHTW60IiuFACeDKpJpJXV9VTOATSA5eTHb0rW5nX/x1wCc/JVTeDKaJC/4Qa3sETdinCjX3qmd88AdzXNVJ9p+aPAx1PvJ6qFjyxOdG/GSSQKyhGLzfY2O2c3cWL/eYqkA5Fj6x4PCQMQehmdSJyopCmhISx+GI7lNyf8ovUhekJhBZ+a7wEQcZWOCcdNxkOJN5+ucrgz+m08oq5JWSYyCFtkRrMMVRHIJO3gpXVQ9iWrzVEZiEZS4JyHoGBK8Y1DF4ubIQzhDXdSI8yXTXzGLJcrDsWTscRStR/E/mqhJLT2Dj/1/zs7p6Q0pVR1FNQanL2jgWGjL6ZueSsQYH2j8XF7RzWbjLcH/Bs/xob0zKrJ6m3TSyfMDB2C5ZSHtdVtTWxKDSdifqSws9s8j/2ngaO6KQThH6o0D6H4QXeIHmX6vnn2uUNl0aiPTwrqawT2mt7vlelVMd4MPhitzmQCt5vZ4Mg8AbW4GVjM5x5ToIyxnT10jZJSeERefIrD5AV/c4Sd/MPibw7/6zXYKeARnsOpImdRKMii3jxBYV3E4XyMdXvgXnNqHbMyX74sRMSy0pgKMjw== travis dever@TravisDever-Laptop"
    aws_controller_security_group_allowed_ips = [
      {
        description = "My Public IP Address",
        cidr_blocks  = local.allowed_public_ips
      }
    ]
    aws_copilot_security_group_allowed_ips = [
      {
        description = "My Public IP Address",
        cidr_blocks  = local.allowed_public_ips
      }
    ]
    aws_controller_instance_size                   = "t3.large"
    aws_copilot_instance_size                      = "t3.2xlarge"
    aviatrix_controller_admin_email                = get_env("ADMIN_EMAIL")
    aviatrix_controller_version                    = "6.6"
    aviatrix_controller_customer_id                = get_env("CONTROLLER_CUSTOMER_ID")
    aviatrix_controller_aws_primary_account_name   = "travis-aws-primary-account"
    aws_copilot_root_volume_size                   = 25
    aws_copilot_additional_volumes = [
      {
        size = 50
      }
    ]
    aws_tags = {
      "CreatedBy" = "Terraform"
      "ownedBy"   = get_env("ADMIN_EMAIL")
    }
}
# enable_auto_aviatrix_controller_security_group_mgmt = true
# enable_auto_aviatrix_copilot_security_group         = true