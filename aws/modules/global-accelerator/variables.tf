variable "name" {
  type = string
}

variable "regions" {
  type = list(object({
    name = string
    endpoints = list(object({
      id     = string
      type   = string
      weight = number
    }))
  }))
  validation {
    condition = alltrue([
      for r in var.regions : (
        alltrue([for e in r.endpoints : contains(["lb", "vm"], e.type)])
      )
    ])
    error_message = "Err: values regions[*].endpoints[*].type is not valid."
  }
  default = []
}

variable "tags" {
  type    = map(any)
  default = null
}
