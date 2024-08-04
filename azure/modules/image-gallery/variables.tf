variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "image_gallery_name" {
  type        = string
  description = "Name of the shared image gallery."
}

variable "image_identifier" {
  type = object({
    publisher = string
    sku       = string
  })
  default = {
    publisher = "devops.mlytics"
    sku       = "Stable"
  }
  description = "Identifier of image definition"
}
