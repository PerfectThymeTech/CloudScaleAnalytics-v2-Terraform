resource "azurerm_data_factory" "data_factory" {
  name                = "${local.prefix}-adf001"
  location            = var.location
  resource_group_name = azurerm_resource_group.runtimes_rg.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  managed_virtual_network_enabled = true
  public_network_enabled          = false
  purview_id                      = var.purview_id
}

resource "azurerm_private_endpoint" "data_factory_private_endpoint_data_factory" {
  name                = "${azurerm_data_factory.data_factory.name}-datafactory-pe"
  location            = var.location
  resource_group_name = azurerm_data_factory.data_factory.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_data_factory.data_factory.name}-datafactory-nic"
  private_service_connection {
    name                           = "${azurerm_data_factory.data_factory.name}-datafactory-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_data_factory.data_factory.id
    subresource_names              = ["dataFactory"]
  }
  subnet_id = azapi_resource.runtimes_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_data_factory == "" ? [] : [1]
    content {
      name = "${azurerm_data_factory.data_factory.name}-datafactory-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_data_factory
      ]
    }
  }
}

resource "azurerm_private_endpoint" "data_factory_private_endpoint_portal" {
  name                = "${azurerm_data_factory.data_factory.name}-portal-pe"
  location            = var.location
  resource_group_name = azurerm_data_factory.data_factory.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_data_factory.data_factory.name}-portal-nic"
  private_service_connection {
    name                           = "${azurerm_data_factory.data_factory.name}-portal-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_data_factory.data_factory.id
    subresource_names              = ["portal"]
  }
  subnet_id = azapi_resource.runtimes_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_data_factory_portal == "" ? [] : [1]
    content {
      name = "${azurerm_data_factory.data_factory.name}-portal-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_data_factory_portal
      ]
    }
  }
}
