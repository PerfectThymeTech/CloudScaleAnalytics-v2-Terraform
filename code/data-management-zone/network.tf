data "azurerm_virtual_network" "virtual_network" {
  name                = local.virtual_network.name
  resource_group_name = local.virtual_network.resource_group_name
}

resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "ServicesSubnet"
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 0))
  ]
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = null
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "private_endpoint_subnet_nsg" {
  network_security_group_id = var.nsg_id
  subnet_id                 = azurerm_subnet.private_endpoint_subnet.id
}

resource "azurerm_subnet_route_table_association" "private_endpoint_subnet_routetable" {
  route_table_id = var.route_table_id
  subnet_id      = azurerm_subnet.private_endpoint_subnet.id
}
