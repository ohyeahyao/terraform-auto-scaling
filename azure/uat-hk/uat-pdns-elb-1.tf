module "uat-pdns-elb-1" {
  source = "../modules/app"

  resource_group_name = local.resource_group_name

  load_balancer = {
    name                    = "uat-pdns-elb-1"
    frontend_config_name    = "uat-pdns-elb-frontend-1"
    frontend_public_ip_name = "uat-pdns-elb-frontend-1-ip"
    backend_pool_name       = "uat-pdns-elb-1"
  }

  vmss = {
    name            = "uat-pdns-vmss-1"
    hostname_prefix = "uat-hk-pdns"
    instance_count  = 0
    capacity = {
      min = 0
      max = 0
    }
  }

  security_group_id = local.pdns.security_gorup_id
  subnet_id         = local.pdns.default_subnet_id

  image_gallery = {
    resource_group_name = local.image.resource_group_name
    gallery_name        = local.image.gallery_name
    image_name          = local.image.image_name
    version             = "2.1.0"
  }
}
