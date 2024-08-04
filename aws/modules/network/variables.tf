variable "vpc" {
  type = object({
    name = string,
    cidr = string
  })
}

variable "subnets" {
  type = list(
    object({
      name    = string,
      cidr    = string
      zone_id = string
    })
  )
  description = "Infomation of Subnets"
}

variable "internet_gateway_name" {
  type        = string
  description = "Infomation of the virtual network"
}
