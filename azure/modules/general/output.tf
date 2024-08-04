output "app_image" {
  value = {
    resource_group_name = module.image_gallery.resource_group_name
    gallery_name        = module.image_gallery.name
    image_name          = module.image_gallery.app_image_definition_name
  }
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "security_group_id" {
  value = module.network.security_group_id
}
