module "prod-pdns-elb-5" {
  source = "../modules/app"

  resource_group_name = local.resource_group_name

  load_balancer = {
    name                    = "prod-pdns-elb-5"
    frontend_config_name    = "prod-pdns-elb-frontend-5"
    frontend_public_ip_name = "prod-pdns-elb-frontend-5-ip"
    backend_pool_name       = "prod-pdns-elb-5"
  }

  vmss = {
    name            = "prod-pdns-vmss-5"
    hostname_prefix = "prod-az2-hk-pdns5"
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
