variable "env" {
  type    = string
  default = null
  validation {
    condition     = contains(["prod", "uat"], var.env)
    error_message = "Allowed values for env are prod or uat."
  }
}

variable "vpc_id" {
  type = string
}

variable "security_group" {
  type = object({
    name = string,
  })
}
