resource "azurerm_storage_account" "datalake" {
  name                = var.datalake_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  access_tier                     = "Hot"
  account_kind                    = "Standard"
  account_replication_type        = "ZRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  allowed_copy_scope              = "AAD"
  blob_properties {
    change_feed_enabled           = false
    change_feed_retention_in_days = 7
    container_delete_retention_policy {
      days = 7
    }
    delete_retention_policy {
      days = 7
    }
    default_service_version  = "2022-09-01"
    last_access_time_enabled = false
    versioning_enabled       = false
  }
  cross_tenant_replication_enabled = false
  default_to_oauth_authentication  = true
  enable_https_traffic_only        = true
  immutability_policy {
    state                         = "Disabled"
    allow_protected_append_writes = true
    period_since_creation_in_days = 7
  }
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

resource "azurerm_storage_container" "datalake_containers" {
  for_each             = var.datalake_filesystem_names
  name                 = each.key
  storage_account_name = azurerm_storage_account.datalake.name

  container_access_type = "private"
}


