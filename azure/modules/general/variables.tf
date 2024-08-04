variable "env" {
  type    = string
  default = null
  validation {
    condition     = contains(["prod", "uat"], var.env)
    error_message = "Error: Allowed values for env are prod or uat."
  }
}

variable "image_gallery" {
  type = object({
    resource_group = string
    name           = string
  })
  default = {
    resource_group = null
    name           = null
  }
}

variable "network" {
  type = object({
    resource_group_name = string
    security_group_name = string
    virtual_network = object({
      name          = string
      address_space = list(string)
    })
    subnets = list(object({
      name           = string
      address_prefix = string
    }))
    ddos_plan = object({
      enable = bool
      id     = string
    })
  })
  default = {
    resource_group_name = null
    security_group_name = null
    subnets = [{
      address_prefix = null
      name           = null
    }]
    virtual_network = {
      address_space = null
      name          = null
    }
    ddos_plan = null
  }
}
