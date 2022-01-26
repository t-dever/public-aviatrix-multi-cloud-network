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


resource "aviatrix_segmentation_security_domain" "segmentation_security_domain" {
  domain_name = var.segmentation_domain_name
}