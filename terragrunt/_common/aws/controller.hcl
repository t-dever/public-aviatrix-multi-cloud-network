terraform {
  source = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/aws/aviatrix_controller?ref=hotfix/AllowAviatrixCredsthruvars"
}

locals {
  path_split                             = split("/", get_terragrunt_dir())                                                                         # path_split: Separates directory into an array/
  environment                            = element(local.path_split, length(local.path_split) - 4)
  global_vars                            = yamldecode(file("${dirname(find_in_parent_folders())}/_common/global_vars.yaml"))
  network_vars                           = yamldecode(file("${dirname(find_in_parent_folders())}/_common/networks.yaml"))
  environment_vars                       = local.global_vars["environments"]["${local.environment}"]
  region                                 = local.environment_vars["region"]
  vpc_address_prefix                     = local.network_vars["${local.environment}"]["aws"]["controller"]
  cidrbits                               = tonumber(split("/", local.vpc_address_prefix)[1])
  subnets                                = cidrsubnets(local.vpc_address_prefix, 26 - local.cidrbits, 26 - local.cidrbits)
  controller_subnet_address_prefix       = local.subnets[0]
  copilot_subnet_address_prefix          = local.subnets[1]
  allowed_public_ips                     = local.network_vars.allowed_public_ips
}


inputs = {
    region                                              = local.region
    aviatrix_role_ec2_name                              = "travis-aviatrix-role-ec2"
    aviatrix_role_app_name                              = "travis-aviatrix-role-app"
    aviatrix_assume_policy_role_policy_name             = "travis-aviatrix-role-ec2-assume-role-policy"
    aviatrix_app_policy_name                            = "travis-aviatrix-role-app-policy"
    vpc_name                                            = "travis-aviatrix-controller-vpc"
    vpc_address_space                                   = local.vpc_address_prefix
    additional_subnets                                  = {}
    aws_key_pair_name                                   = "aviatrix-controller-key"
    aws_key_pair_public_key                             = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3e8QwCWEfjbI0VeuqzAfB2YQYlA4uZK70MfUG2kd1AadMs0jJMIurvzpKMgC3hSvIb9s0hGsGLPv7REO+TCtNXS+vhaHkQxVFGnIHTW60IiuFACeDKpJpJXV9VTOATSA5eTHb0rW5nX/x1wCc/JVTeDKaJC/4Qa3sETdinCjX3qmd88AdzXNVJ9p+aPAx1PvJ6qFjyxOdG/GSSQKyhGLzfY2O2c3cWL/eYqkA5Fj6x4PCQMQehmdSJyopCmhISx+GI7lNyf8ovUhekJhBZ+a7wEQcZWOCcdNxkOJN5+ucrgz+m08oq5JWSYyCFtkRrMMVRHIJO3gpXVQ9iWrzVEZiEZS4JyHoGBK8Y1DF4ubIQzhDXdSI8yXTXzGLJcrDsWTscRStR/E/mqhJLT2Dj/1/zs7p6Q0pVR1FNQanL2jgWGjL6ZueSsQYH2j8XF7RzWbjLcH/Bs/xob0zKrJ6m3TSyfMDB2C5ZSHtdVtTWxKDSdifqSws9s8j/2ngaO6KQThH6o0D6H4QXeIHmX6vnn2uUNl0aiPTwrqawT2mt7vlelVMd4MPhitzmQCt5vZ4Mg8AbW4GVjM5x5ToIyxnT10jZJSeERefIrD5AV/c4Sd/MPibw7/6zXYKeARnsOpImdRKMii3jxBYV3E4XyMdXvgXnNqHbMyX74sRMSy0pgKMjw== travis dever@TravisDever-Laptop"
    allowed_ips                                         = local.allowed_public_ips
    aviatrix_controller_name                            = "travis-aviatrix-controller"
    aviatrix_controller_security_group_name             = "aviatrix-controller-security-group"
    aviatrix_copilot_security_group_name                = "aviatrix-copilot-security-group"
    enable_auto_aviatrix_controller_security_group_mgmt = true
    enable_auto_aviatrix_copilot_security_group         = true
    deploy_aviatrix_copilot                             = true
    aviatrix_controller_instance_size                   = "t3.large"
    aviatrix_controller_admin_email                     = get_env("ADMIN_EMAIL")
    aviatrix_controller_version                         = "6.6"
    aviatrix_controller_customer_id                     = get_env("CONTROLLER_CUSTOMER_ID")
    aviatrix_aws_primary_account_name                   = "travis-aws-primary-account"
    aviatrix_copilot_name                               = "travis-aviatrix-copilot"
    aviatrix_copilot_instance_size                      = "t3.2xlarge"
    aviatrix_copilot_root_volume_size                   = 25
    aviatrix_copilot_additional_volumes = [
      {
        size = 50
      }
    ]
    tags = {
      "CreatedBy" = "Terraform"
      "ownedBy"   = get_env("ADMIN_EMAIL")
    }
    aviatrix_controller_subnet = {
      name              = "aviatrix-controller"
      cidr_block        = local.controller_subnet_address_prefix
      availability_zone = "${local.region}a"
    }
    aviatrix_copilot_subnet = {
      name              = "aviatrix-copilot"
      cidr_block        = local.copilot_subnet_address_prefix
      availability_zone = "${local.region}b"
    }
}