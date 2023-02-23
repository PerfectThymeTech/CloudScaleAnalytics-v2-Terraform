resource "azurerm_storage_account" "datalake" {
  name                = replace("${local.prefix}-st001", "-", "")
  location            = var.location
  resource_group_name = azurerm_resource_group.unity_rg.name
  tags                = var.tags

  access_tier                     = "Hot"
  account_kind                    = "StorageV2"
  account_replication_type        = "ZRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  allowed_copy_scope              = "AAD"
  blob_properties {
    change_feed_enabled = false
    # change_feed_retention_in_days = 7
    container_delete_retention_policy {
      days = 7
    }
    delete_retention_policy {
      days = 7
    }
    # default_service_version  = "2020-06-12"
    last_access_time_enabled = false
    versioning_enabled       = false
  }
  cross_tenant_replication_enabled = false
  default_to_oauth_authentication  = true
  enable_https_traffic_only        = true
  # immutability_policy {  # Not supported for ADLS Gen2
  #   state                         = "Disabled"
  #   allow_protected_append_writes = true
  #   period_since_creation_in_days = 7
  # }
  infrastructure_encryption_enabled = true
  is_hns_enabled                    = true
  large_file_share_enabled          = false
  min_tls_version                   = "TLS1_2"
  network_rules {
    bypass                     = ["None"]
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  nfsv3_enabled                 = false
  public_network_access_enabled = true
  queue_encryption_key_type     = "Service"
  table_encryption_key_type     = "Service"
  routing {
    choice                      = "MicrosoftRouting"
    publish_internet_endpoints  = false
    publish_microsoft_endpoints = false
  }
  sftp_enabled              = false
  shared_access_key_enabled = false
}

resource "azurerm_storage_management_policy" "datalake_management_policy" {
  storage_account_id = azurerm_storage_account.datalake.id

  rule {
    name    = "default"
    enabled = true
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = 360
        # delete_after_days_since_modification_greater_than = 720
      }
      snapshot {
        change_tier_to_cool_after_days_since_creation = 180
        delete_after_days_since_creation_greater_than = 360
      }
      version {
        change_tier_to_cool_after_days_since_creation = 180
        delete_after_days_since_creation              = 360
      }
    }
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = []
    }
  }
}

resource "azurerm_storage_container" "datalake_containers" {
  name                 = local.unity_container_name
  storage_account_name = azurerm_storage_account.datalake.name

  container_access_type = "private"
}

resource "azurerm_private_endpoint" "datalake_private_endpoint_blob" {
  name                = "${azurerm_storage_account.datalake.name}-blob-pe"
  location            = var.location
  resource_group_name = azurerm_storage_account.datalake.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_storage_account.datalake.name}-blob-nic"
  private_service_connection {
    name                           = "${azurerm_storage_account.datalake.name}-blob-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.datalake.id
    subresource_names              = ["blob"]
  }
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_blob == "" ? [] : [1]
    content {
      name = "${azurerm_storage_account.datalake.name}-blob-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_blob
      ]
    }
  }
}

resource "azurerm_private_endpoint" "datalake_private_endpoint_dfs" {
  name                = "${azurerm_storage_account.datalake.name}-dfs-pe"
  location            = var.location
  resource_group_name = azurerm_storage_account.datalake.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_storage_account.datalake.name}-dfs-nic"
  private_service_connection {
    name                           = "${azurerm_storage_account.datalake.name}-dfs-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.datalake.id
    subresource_names              = ["dfs"]
  }
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_dfs == "" ? [] : [1]
    content {
      name = "${azurerm_storage_account.datalake.name}-dfs-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_dfs
      ]
    }
  }
}
