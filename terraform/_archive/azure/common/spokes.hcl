# This specifies the default tag/reference for the spoke module
terraform {
  source = "${local.base_source_url}?ref=features/addAzureSpokes"
}

# These are the spoke level variables
locals {
  base_source_url = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/azure/spokes"
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment
}
