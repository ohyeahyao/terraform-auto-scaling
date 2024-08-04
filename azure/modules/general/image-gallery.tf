module "image_gallery" {
  source = "../image-gallery"

  resource_group_name = var.image_gallery.resource_group
  image_gallery_name  = var.image_gallery.name

  image_identifier = {
    publisher = "mlytics"
    sku       = "Stable"
  }
}

