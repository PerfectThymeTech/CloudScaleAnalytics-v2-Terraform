resource "azurerm_purview_account" "purview" {
  name = "${local.prefix}-purview001"
  location = var.location
  resource_group_name = azurerm_resource_group.governance_rg.name
  tags = var.tags
  identity {
    type = "SystemAssigned"
  }
  managed_resource_group_name = "${purview.name}-rg"
  public_network_enabled = false
}

resource "azapi_resource" "purviewKafkaConfigurationNotification" {
  type = "Microsoft.Purview/accounts/kafkaConfigurations@2021-12-01"
  name = "notification"
  parent_id = azurerm_purview_account.purview.id

  body = jsonencode({
    properties = {
      credentials: {
        type: "SystemAssigned"
      }
      eventHubResourceId = 
      eventHubType = "Notification"
      eventStreamingState = "Enabled"
      eventStreamingType = "Azure"
    }
  })
}

resource "azapi_resource" "purviewKafkaConfigurationHook" {
  type = "Microsoft.Purview/accounts/kafkaConfigurations@2021-12-01"
  name = "notification"
  parent_id = azurerm_purview_account.purview.id

  body = jsonencode({
    properties = {
      credentials: {
        type: "SystemAssigned"
      }
      eventHubResourceId = 
      eventHubType = "Hook"
      eventStreamingState = "Enabled"
      eventStreamingType = "Azure"
      consumerGroup = "$Default"
    }
  })
}
