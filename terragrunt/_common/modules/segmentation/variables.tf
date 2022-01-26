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

variable "segmentation_domain_name" {
  type = string
  description = "The name of the segmentation domain to be created."
}
