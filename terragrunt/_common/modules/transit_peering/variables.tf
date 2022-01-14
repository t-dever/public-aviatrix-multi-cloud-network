variable "transit_gateway_peerings" {
  type = list(object({
      transit_gateway_1 = string
      transit_gateway_2 = string
  }))
}