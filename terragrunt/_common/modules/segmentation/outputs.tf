output "segmentation_domain_connection_policies" {
  value = aviatrix_segmentation_security_domain_connection_policy.segmentation_security_domain_connection_policy[*]
  description = "The segmentation domains created"
}