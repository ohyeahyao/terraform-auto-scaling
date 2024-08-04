variable "env" {
  type    = string
  default = null
  validation {
    condition     = contains(["prod", "uat"], var.env)
    error_message = "Allowed values for env are prod or uat."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "security_gorup" {
  type = object({
    name = string,
  })
  description = "Infomation of the security group"
}

variable "virtual_network" {
  type = object({
    name          = string,
    address_space = list(string)
    dns_servers   = list(string)
  })
  description = "Infomation of the virtual network"
}

variable "subnets" {
  type = list(
    object({
      name           = string,
      address_prefix = string
    })
  )
  description = "Infomation of Subnets"
}

variable "ddos_plan" {
  type = object({
    enable = bool
    id     = string
  })

  default = null
}
