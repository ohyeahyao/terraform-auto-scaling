data "azurerm_resource_group" "default" {
  name = var.resource_group_name
}

data "azurerm_shared_image_version" "app_image" {
  resource_group_name = var.image_gallery.resource_group_name

  gallery_name = var.image_gallery.gallery_name
  image_name   = var.image_gallery.image_name
  name         = var.image_gallery.version
}
