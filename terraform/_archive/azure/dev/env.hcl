locals {
  environment                      = "dev"
  ctrlip                           = "" # Example: "40.84.211.194"
  ctrlpassword                     = get_env("AVIATRIX_CONTROLLER_PASSWORD") # Best to pass this in through environment variables
}