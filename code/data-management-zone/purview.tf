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

# Fix for issue where the managed resource IDs are not being exported
data "azapi_resource" "purview" {
  resource_id = azurerm_purview_account.purview.id
  type        = "Microsoft.Purview/accounts@2021-07-01"
  response_export_values = [
    "properties.managedResources.storageAccount",
    "properties.managedResources.eventHubNamespace"
  ]
}

# resource "azapi_update_resource" "purview_kafka_configuration_notification" {
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

# resource "azapi_update_resource" "purview_kafka_configuration_hook" {
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

resource "azurerm_private_endpoint" "purview_private_endpoint_account" {
  name                = "${azurerm_purview_account.purview.name}-account-pe"
  location            = var.location
  resource_group_name = azurerm_purview_account.purview.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_purview_account.purview.name}-account-nic"
  private_service_connection {
    name                           = "${azurerm_purview_account.purview.name}-account-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_purview_account.purview.id
    subresource_names              = ["account"]
  }
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_purview_account == "" ? [] : [1]
    content {
      name = "${azurerm_purview_account.purview.name}-account-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_purview_account
      ]
    }
  }
}

resource "azurerm_private_endpoint" "purview_private_endpoint_portal" {
  name                = "${azurerm_purview_account.purview.name}-portal-pe"
  location            = var.location
  resource_group_name = azurerm_purview_account.purview.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_purview_account.purview.name}-portal-nic"
  private_service_connection {
    name                           = "${azurerm_purview_account.purview.name}-portal-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_purview_account.purview.id
    subresource_names              = ["portal"]
  }
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_purview_portal == "" ? [] : [1]
    content {
      name = "${azurerm_purview_account.purview.name}-portal-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_purview_portal
      ]
    }
  }
}

resource "azurerm_private_endpoint" "purview_private_endpoint_blob" {
  name                = "${azurerm_purview_account.purview.name}-pe-blob"
  location            = var.location
  resource_group_name = azurerm_purview_account.purview.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_purview_account.purview.name}-blob-nic"
  private_service_connection {
    name                           = "${azurerm_purview_account.purview.name}-blob-pe"
    is_manual_connection           = false
    private_connection_resource_id = jsondecode(data.azapi_resource.purview.output).properties.managedResources.storageAccount # azurerm_purview_account.purview.managed_resources.storage_account_id
    subresource_names              = ["blob"]
  }
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_blob == "" ? [] : [1]
    content {
      name = "${azurerm_purview_account.purview.name}-blob-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_blob
      ]
    }
  }
}

resource "azurerm_private_endpoint" "purview_private_endpoint_queue" {
  name                = "${azurerm_purview_account.purview.name}-pe-queue"
  location            = var.location
  resource_group_name = azurerm_purview_account.purview.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_purview_account.purview.name}-queue-nic"
  private_service_connection {
    name                           = "${azurerm_purview_account.purview.name}-queue-pe"
    is_manual_connection           = false
    private_connection_resource_id = jsondecode(data.azapi_resource.purview.output).properties.managedResources.storageAccount # azurerm_purview_account.purview.managed_resources.storage_account_id
    subresource_names              = ["queue"]
  }
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_queue == "" ? [] : [1]
    content {
      name = "${azurerm_purview_account.purview.name}-queue-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_queue
      ]
    }
  }
}

resource "azurerm_private_endpoint" "purview_private_endpoint_namespace" {
  name                = "${azurerm_purview_account.purview.name}-pe-namespace"
  location            = var.location
  resource_group_name = azurerm_purview_account.purview.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_purview_account.purview.name}-namespace-nic"
  private_service_connection {
    name                           = "${azurerm_purview_account.purview.name}-namespace-pe"
    is_manual_connection           = false
    private_connection_resource_id = jsondecode(data.azapi_resource.purview.output).properties.managedResources.eventHubNamespace # azurerm_purview_account.purview.managed_resources.event_hub_namespace
    subresource_names              = ["namespace"]
  }
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_namespace == "" ? [] : [1]
    content {
      name = "${azurerm_purview_account.purview.name}-namespace-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_namespace
      ]
    }
  }
}
