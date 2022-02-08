locals {
  allowed_public_ips = [
    "209.169.92.39" # user public IP
  ]
  dev = {
    azure = {
      south-central-us = {
        transit = "10.0.0.0/23"
        spokes = {
          spoke1 = "10.0.2.0/23"
        }
      }
      east-us-1 = {
        transit = "10.1.0.0/23"
        spokes = {
          spoke1 = "10.1.2.0/23"
          spoke2 = "10.1.4.0/23"
        }
      }
    }
  }
}
