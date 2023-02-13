resource "azurerm_container_registry" "container_registry" {
  name                = replace("${local.prefix}-acr001", "-", "")
  location            = var.location
  resource_group_name = azurerm_resource_group.container_rg.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  admin_enabled              = false
  anonymous_pull_enabled     = false
  data_endpoint_enabled      = false
  export_policy_enabled      = true
  network_rule_bypass_option = "None"
  network_rule_set = [
    {
      default_action  = "Deny"
      ip_rule         = []
      virtual_network = []
    }
  ]
  public_network_access_enabled = false
  quarantine_policy_enabled     = true
  retention_policy = [
    {
      days    = 7
      enabled = true
    }
  ]
  sku = "Premium"
  trust_policy = [
    {
      enabled = false
    }
  ]
  zone_redundancy_enabled = true
}

resource "azurerm_private_endpoint" "container_registry_private_endpoint" {
  name                = "${azurerm_container_registry.container_registry.name}-pe"
  location            = var.location
  resource_group_name = azurerm_container_registry.container_registry.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_container_registry.container_registry.name}-nic"
  private_service_connection {
    name                           = "${azurerm_container_registry.container_registry.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_container_registry.container_registry.id
    subresource_names              = ["registry"]
  }
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_container_registry == "" ? [] : [1]
    content {
      name = "${azurerm_container_registry.container_registry.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_container_registry
      ]
    }
  }
}
