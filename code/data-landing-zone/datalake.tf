resource "azurerm_storage_account" "datalake" {
  name = ""
  location = var.location
  resource_group_name = azurerm_resource_group.storage_rg.name
  tags = var.tags

  access_tier = "Hot"
  account_kind = "Standard"
  account_replication_type = "ZRS"
  account_tier = "Standard"
  allow_nested_items_to_be_public = false
  allowed_copy_scope = "AAD"
  blob_properties {
    change_feed_enabled = false
    change_feed_retention_in_days = 7
    container_delete_retention_policy {
      days = 7
    }
    cors_rule {}
    delete_retention_policy {
      days = 7
    }
    default_service_version = "2022-09-01"
    last_access_time_enabled = false
    versioning_enabled = false

  }
}