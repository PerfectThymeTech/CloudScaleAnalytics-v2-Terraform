resource "azurerm_synapse_private_link_hub" "synapse_pl_hub" {
  name                = "${local.prefix}-synplh001"
  location            = var.location
  resource_group_name = azurerm_resource_group.consumption_rg.name
  tags                = var.tags
}

resource "azurerm_private_endpoint" "synapse_pl_hub_private_endpoint" {
  name                = "${azurerm_synapse_private_link_hub.synapse_pl_hub.name}-pe"
  location            = var.location
  resource_group_name = azurerm_synapse_private_link_hub.synapse_pl_hub.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_synapse_private_link_hub.synapse_pl_hub.name}-nic"
  private_service_connection {
    name                           = "${azurerm_synapse_private_link_hub.synapse_pl_hub.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_synapse_private_link_hub.synapse_pl_hub.id
    subresource_names              = ["web"]
  }
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_synapse_portal == "" ? [] : [1]
    content {
      name = "${azurerm_synapse_private_link_hub.synapse_pl_hub.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_synapse_portal
      ]
    }
  }
}
