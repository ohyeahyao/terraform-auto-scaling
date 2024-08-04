output "security_group_id" {
  value = azurerm_network_security_group.default.id
}

output "subnet_ids" {
  value = {
    for subnet in azurerm_virtual_network.default.subnet : subnet.name => subnet.id
  }
}
