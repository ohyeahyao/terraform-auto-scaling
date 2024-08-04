variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "load_balancer" {
  type = object({
    name                    = string
    frontend_config_name    = string
    frontend_public_ip_name = string
    backend_pool_name       = string
  })
  description = "Info of the Load Balancer"
}

variable "vmss" {
  type = object({
    name            = string
    instance_count  = number
    hostname_prefix = string
    capacity = object({
      min = number
      max = number
    })
  })
}

variable "security_group_id" {
  type    = string
  default = null
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "image_gallery" {
  type = object({
    resource_group_name = string
    gallery_name        = string
    image_name          = string
    version             = string
  })
}

variable "notify_emails" {
  type    = list(string)
  default = ["zone.yao@mlytics.com"]
}
