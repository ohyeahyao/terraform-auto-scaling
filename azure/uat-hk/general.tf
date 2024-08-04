
module "general" {
  source = "../modules/general"

  env = "uat"

  image_gallery = {
    resource_group = "PDNS-UAT-Images"
    name           = "PDNS_UAT_SIG"
  }

  network = {
    resource_group_name = local.resource_group_name

    security_group_name = local.general.security_group_name

    virtual_network = {
      name          = "pdns-vnet",
      address_space = ["10.1.0.0/16"]
    }

    subnets = [
      {
        name           = "default"
        address_prefix = "10.1.0.0/24"
      }
    ]

    ddos_plan = null
  }
}
