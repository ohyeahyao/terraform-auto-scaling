locals {
  resource_group_name = "PDNS-UAT-App"

  general = {
    security_group_name = "uat-pdns-nsg"
  }

  pdns = {
    security_gorup_id = module.general.security_group_id
    default_subnet_id = module.general.subnet_ids["default"]
  }

  image = {
    resource_group_name = module.general.app_image.resource_group_name
    gallery_name        = module.general.app_image.gallery_name
    image_name          = module.general.app_image.image_name
  }
}
