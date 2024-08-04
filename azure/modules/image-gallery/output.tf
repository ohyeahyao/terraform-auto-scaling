output "name" {
  value = azurerm_shared_image_gallery.default.name
}

output "resource_group_name" {
  value = azurerm_shared_image_gallery.default.resource_group_name
}

output "app_image_definition_name" {
  value = azurerm_shared_image.app_image.name
}
