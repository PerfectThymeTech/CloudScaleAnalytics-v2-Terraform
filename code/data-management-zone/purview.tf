resource "azurerm_purview_account" "purview" {
  name                = "${local.prefix}-pview001"
  location            = var.location
  resource_group_name = azurerm_resource_group.governance_rg.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
  managed_resource_group_name = "${local.prefix}-pview001-rg"
  public_network_enabled      = false
}

# resource "azapi_resource" "purview_kafka_configuration_notification" {
#   type = "Microsoft.Purview/accounts/kafkaConfigurations@2021-12-01"
#   name = "notification"
#   parent_id = azurerm_purview_account.purview.id

#   body = jsonencode({
#     properties = {
#       credentials: {
#         type: "SystemAssigned"
#       }
#       eventHubResourceId = azurerm_eventhub.eventhub_notification.id
#       eventHubType = "Notification"
#       eventStreamingState = "Enabled"
#       eventStreamingType = "Azure"
#     }
#   })
# }

# resource "azapi_resource" "purview_kafka_configuration_hook" {
#   type = "Microsoft.Purview/accounts/kafkaConfigurations@2021-12-01"
#   name = "notification"
#   parent_id = azurerm_purview_account.purview.id

#   body = jsonencode({
#     properties = {
#       credentials: {
#         type: "SystemAssigned"
#       }
#       eventHubResourceId = azurerm_eventhub.eventhub_hook.id
#       eventHubType = "Hook"
#       eventStreamingState = "Enabled"
#       eventStreamingType = "Azure"
#       consumerGroup = "$Default"
#     }
#   })
# }
