module "network" {
  source = "../network"

  env = var.env

  resource_group_name = var.network.resource_group_name

  security_gorup = {
    name = var.network.security_group_name
  }

  virtual_network = {
    name          = var.network.virtual_network.name,
    address_space = var.network.virtual_network.address_space
    dns_servers   = []
  }

  subnets = var.network.subnets

  ddos_plan = var.network.ddos_plan
}
