locals {
  lb_frontend_ip_name     = var.load_balancer.frontend_public_ip_name
  lb_frontend_config_name = var.load_balancer.frontend_config_name
  lb_backend_pool_name    = var.load_balancer.backend_pool_name
}

resource "azurerm_public_ip" "default" {
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location

  name              = local.lb_frontend_ip_name
  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_lb" "default" {
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location

  name = var.load_balancer.name
  sku  = "Standard"
  frontend_ip_configuration {
    name                 = local.lb_frontend_config_name
    public_ip_address_id = azurerm_public_ip.default.id
  }
}

resource "azurerm_lb_probe" "tcp_53_probe" {
  name                = "tcp53"
  loadbalancer_id     = azurerm_lb.default.id
  protocol            = "Tcp"
  port                = 53
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_backend_address_pool" "old_backend" {
  loadbalancer_id = azurerm_lb.default.id
  name            = local.lb_backend_pool_name
}

resource "azurerm_lb_rule" "udp_53_rule" {
  name            = "udp53"
  loadbalancer_id = azurerm_lb.default.id
  protocol        = "Udp"
  probe_id        = azurerm_lb_probe.tcp_53_probe.id

  frontend_port                  = 53
  frontend_ip_configuration_name = local.lb_frontend_config_name

  backend_port = 53
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.old_backend.id
  ]


  enable_floating_ip    = false     // default
  load_distribution     = "Default" // 5 tuple hash
  disable_outbound_snat = true
}

resource "azurerm_lb_rule" "tcp_53_rule" {
  name            = "tcp53"
  loadbalancer_id = azurerm_lb.default.id
  protocol        = "Tcp"
  probe_id        = azurerm_lb_probe.tcp_53_probe.id

  frontend_port                  = 53
  frontend_ip_configuration_name = local.lb_frontend_config_name

  backend_port = 53
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.old_backend.id
  ]

  enable_floating_ip    = false     // default
  load_distribution     = "Default" // 5 tuple hash
  disable_outbound_snat = true
}
