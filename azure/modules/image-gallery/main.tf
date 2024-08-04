
data "azurerm_resource_group" "default" {
  name = var.resource_group_name
}

resource "azurerm_shared_image_gallery" "default" {
  name                = var.image_gallery_name
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location
  description         = "Shared images and things."

  tags = {
    CreatedBy = "Terraform"
  }
}

resource "azurerm_shared_image" "base_image" {
  name                = "Base-Image"
  gallery_name        = azurerm_shared_image_gallery.default.name
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location
  os_type             = "Linux"

  identifier {
    offer     = "PDNS-Base-Image"
    publisher = var.image_identifier.publisher
    sku       = var.image_identifier.sku
  }
}

resource "azurerm_shared_image" "app_image" {
  name                = "Application-Image"
  gallery_name        = azurerm_shared_image_gallery.default.name
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location
  os_type             = "Linux"

  identifier {
    offer     = "PDNS-App-Image"
    publisher = var.image_identifier.publisher
    sku       = var.image_identifier.sku
  }
}
