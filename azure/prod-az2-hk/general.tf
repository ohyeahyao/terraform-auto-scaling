
module "general" {
  source = "../modules/general"

  env = "prod"

  image_gallery = {
    resource_group = "PDNS-PROD-Images"
    name           = "PDNS_PROD_SIG"
  }

  network = {
    resource_group_name = local.resource_group_name

    security_group_name = local.general.security_group_name

    virtual_network = {
      name          = "Mly-DDos-pdns-vnet",
      address_space = ["10.1.0.0/16"]
    }

    subnets = [
      {
        name           = "default"
        address_prefix = "10.1.0.0/24"
      }
    ]

    ddos_plan = {
      enable = true
      id     = data.azurerm_network_ddos_protection_plan.default.id
    }
  }
}
