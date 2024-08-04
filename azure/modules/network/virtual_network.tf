resource "azurerm_virtual_network" "default" {
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location

  name          = var.virtual_network.name
  address_space = var.virtual_network.address_space
  dns_servers   = var.virtual_network.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_plan == null ? [] : [true]
    content {
      enable = var.ddos_plan.enable
      id     = var.ddos_plan.id
    }
  }

  dynamic "subnet" {
    for_each = var.subnets
    content {
      name           = subnet.value["name"]
      address_prefix = subnet.value["address_prefix"]
    }
  }

  tags = {
    CreatedBy = "Terraform"
    Name      = ""
  }
}
