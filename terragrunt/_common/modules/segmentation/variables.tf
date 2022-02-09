variable "controller_username" {
  description = "The controllers username."
  type        = string
  sensitive   = true
}

variable "controller_password" {
  description = "The controllers password."
  type        = string
  sensitive   = true
}

variable "controller_public_ip" {
  description = "The controllers public IP address."
  type        = string
  sensitive   = true
}

variable "segmentation_domain_connection_policies" {
  description = "The segementation domain connection policies to associate to the spoke."
  type        = list(object({
    domain1 = string
    domain2 = string
  }))
}
