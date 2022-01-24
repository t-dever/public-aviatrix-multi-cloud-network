terraform {
  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = "2.21.0-6.6.ga"
    }
  }
}


resource "aviatrix_segmentation_security_domain" "segmentation_security_domain" {
  domain_name = var.segmentation_domain_name
}