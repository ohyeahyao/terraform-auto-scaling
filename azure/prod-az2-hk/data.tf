data "azurerm_network_ddos_protection_plan" "default" {
  name                = "DDoS-East-Asia"
  resource_group_name = "Mly-DDos-waf"
}
