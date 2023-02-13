resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                = "${local.prefix}-evhns001"
  location            = var.location
  resource_group_name = azurerm_resource_group.governance_rg.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  auto_inflate_enabled         = true
  capacity                     = local.eventhub_namespace.min_throughput
  maximum_throughput_units     = local.eventhub_namespace.max_throughput
  local_authentication_enabled = false
  minimum_tls_version          = "1.2"
  network_rulesets = [
    {
      default_action                 = "Deny"
      ip_rule                        = []
      public_network_access_enabled  = false
      trusted_service_access_enabled = false
      virtual_network_rule           = []
    }
  ]
  public_network_access_enabled = false
  sku                           = "Standard"
}

resource "azurerm_eventhub" "eventhub_notification" {
  name                = local.eventhub_namespace.eventhub_notification.name
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = azurerm_eventhub_namespace.eventhub_namespace.resource_group_name

  # capture_description {  # Enable this to capture data in a storage account.
  #   enabled = false
  #   destination {
  #     name = "EventHubArchive.AzureBlockBlob"
  #     archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
  #     blob_container_name = ""
  #     storage_account_id = ""
  #   }
  #   encoding = "Avro"
  #   interval_in_seconds = 900
  #   size_limit_in_bytes = 10485760
  #   skip_empty_archives = true
  # }
  message_retention = local.eventhub_namespace.eventhub_notification.message_retention
  partition_count   = local.eventhub_namespace.eventhub_notification.partition_count
}

resource "azurerm_eventhub" "eventhub_hook" {
  name                = local.eventhub_namespace.eventhub_hook.name
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = azurerm_eventhub_namespace.eventhub_namespace.resource_group_name

  # capture_description {  # Enable this to capture data in a storage account.
  #   enabled = false
  #   destination {
  #     name = "EventHubArchive.AzureBlockBlob"
  #     archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
  #     blob_container_name = ""
  #     storage_account_id = ""
  #   }
  #   encoding = "Avro"
  #   interval_in_seconds = 900
  #   size_limit_in_bytes = 10485760
  #   skip_empty_archives = true
  # }
  message_retention = local.eventhub_namespace.eventhub_hook.message_retention
  partition_count   = local.eventhub_namespace.eventhub_hook.partition_count
}

resource "azurerm_private_endpoint" "eventhub_namespace_private_endpoint" {
  name                = "${azurerm_eventhub_namespace.eventhub_namespace.name}-pe"
  location            = var.location
  resource_group_name = azurerm_eventhub_namespace.eventhub_namespace.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_eventhub_namespace.eventhub_namespace.name}-nic"
  private_service_connection {
    name                           = "${azurerm_eventhub_namespace.eventhub_namespace.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_eventhub_namespace.eventhub_namespace.id
    subresource_names              = ["namespace"]
  }
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_namespace == "" ? [] : [1]
    content {
      name = "${azurerm_eventhub_namespace.eventhub_namespace.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_namespace
      ]
    }
  }
}
