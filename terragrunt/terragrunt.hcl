# Recommendation, enable RBAC for azure storage account state file access
# terraform {
#   backend "local" {
#     path = "${path_relative_to_include()}.terraform.tfstate"
#   }
# }

# Generating this default "backend" is required but it's not actually used.
# generate "backend" {
#   path      = "backend.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# terraform {
#   backend "local" {}
# }
# EOF
# }


remote_state {
  backend = "local"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    path = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/terraform.tfstate"
  }
}