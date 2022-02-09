terraform {
  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = "2.21.0-6.6.ga"
    }
  }
}

provider "aviatrix" {
  controller_ip = var.controller_public_ip
  username      = var.controller_username
  password      = var.controller_password
}

resource "aviatrix_segmentation_security_domain_connection_policy" "segmentation_security_domain_connection_policy" {
  for_each      = { for idx, domain in var.segmentation_domain_connection_policies: idx => domain }
  domain_name_1 = each.value.domain1
  domain_name_2 = each.value.domain2
}