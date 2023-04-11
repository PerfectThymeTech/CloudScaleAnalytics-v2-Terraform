data "azurerm_virtual_network" "virtual_network" {
  name                = local.virtual_network.name
  resource_group_name = local.virtual_network.resource_group_name
}

data "azurerm_network_security_group" "network_security_group" {
  name                = local.network_security_group.name
  resource_group_name = local.network_security_group.resource_group_name
}

data "azurerm_route_table" "route_table" {
  name                = local.route_table.name
  resource_group_name = local.route_table.resource_group_name
}

resource "azapi_resource" "subnet" {
  count     = var.network_enabled ? 1 : 0
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "DataProductSubnet-${var.data_product_name}"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = var.subnet_cidr_range
      delegations   = []
      ipAllocations = []
      networkSecurityGroup = {
        id = data.azurerm_network_security_group.network_security_group.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = data.azurerm_route_table.route_table.id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  })
}
