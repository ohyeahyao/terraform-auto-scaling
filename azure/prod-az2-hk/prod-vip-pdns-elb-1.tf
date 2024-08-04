module "prod-vip-pdns-elb-1" {
  source = "../modules/app"

  resource_group_name = local.resource_group_name

  load_balancer = {
    name                    = "prod-vip-pdns-elb-1"
    frontend_config_name    = "prod-pdns-elb-frontend-1"
    frontend_public_ip_name = "prod-vip-pdns-elb-1"
    backend_pool_name       = "prod-vip-pdns-elb-backend-1"
  }

  vmss = {
    name            = "prod-vip-pdns-vmss-1"
    hostname_prefix = "prod-az2-hk-vip-pdns1"
    instance_count  = 0
    capacity = {
      min = 0
      max = 16
    }
  }

  security_group_id = local.pdns.security_gorup_id
  subnet_id         = local.pdns.default_subnet_id

  image_gallery = {
    resource_group_name = local.image.resource_group_name
    gallery_name        = local.image.gallery_name
    image_name          = local.image.image_name
    version             = "2.2.0"
  }

  notify_emails = ["devops@mlyitcs.com", "alerts@mlytics.com"]
}
