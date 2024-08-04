locals {
  tcp_port22_10050_ips_data = {
    "prod" = [
      "47.52.237.32",  // Zabbix Proxy
      "35.187.153.14", // Zabbix Server
      "47.115.1.225",  // prod-hk-zabbix-proxy-1
    ]
    "uat" = [
      "34.80.43.213" // Zabbix-UAT
    ]
  }
  tcp_port22_10050_ips = local.tcp_port22_10050_ips_data[var.env]
}

resource "azurerm_network_security_group" "default" {
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location

  name = var.security_gorup.name

  tags = {
    CreatedBy = "Terraform"
  }
}

resource "azurerm_network_security_rule" "tcp_port22" {
  resource_group_name         = data.azurerm_resource_group.default.name
  network_security_group_name = azurerm_network_security_group.default.name

  name      = "TCP_Port_22"
  priority  = 1001
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range = "*"
  source_address_prefixes = [
    # "59.124.115.31/32",  // 公司 IP
    # "59.124.115.32/32",  // 公司 IP
    # "59.124.115.33/32",  // 公司 IP
    # "59.124.115.147/32", // 公司 IP
    # "59.124.115.225/32", // 公司 IP
    "59.124.115.148/32", // 公司 IP
    "35.194.232.181/32", // VPN
    "35.187.153.14/32",  // Zabbix Server
    "47.52.237.32/32",   // Zabbix Proxy
    "35.185.149.71/32",  // Jump1
    "47.101.45.217/32",  // Jump2
    "35.221.243.190/32"  // CMDB Server
  ]

  destination_port_range     = "22"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "udp_port53" {
  resource_group_name         = data.azurerm_resource_group.default.name
  network_security_group_name = azurerm_network_security_group.default.name

  name      = "UDP_Port_53"
  priority  = 900
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Udp"

  source_port_range     = "*"
  source_address_prefix = "*"

  destination_port_range     = "53"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "tcp_port53" {
  resource_group_name         = data.azurerm_resource_group.default.name
  network_security_group_name = azurerm_network_security_group.default.name

  name      = "TCP_Port_53"
  priority  = 1000
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range     = "*"
  source_address_prefix = "*"

  destination_port_range     = "53"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "tcp_port22_10050" {
  resource_group_name         = data.azurerm_resource_group.default.name
  network_security_group_name = azurerm_network_security_group.default.name

  name      = "TCP_Port_22_10050"
  priority  = 1002
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range       = "*"
  source_address_prefixes = local.tcp_port22_10050_ips

  destination_port_ranges    = ["22", "10050"]
  destination_address_prefix = "*"
}
