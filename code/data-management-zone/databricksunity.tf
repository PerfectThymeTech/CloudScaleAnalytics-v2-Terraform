resource "databricks_metastore" "metastore" {
  name = lower("${var.company_name}-${title(var.location)}")

  delta_sharing_organization_name                   = lower(var.company_name)
  delta_sharing_recipient_token_lifetime_in_seconds = 0
  delta_sharing_scope                               = "INTERNAL"
  owner                                             = data.azurerm_client_config.current.client_id
  storage_root                                      = "abfss://${azurerm_storage_account.datalake.name}@${azapi_resource.datalake_container_unity.name}.dfs.core.windows.net/"
  force_destroy                                     = true

  depends_on = [
    azurerm_databricks_access_connector.databricks_access_connector,
    azurerm_databricks_workspace.databricks,
    azurerm_private_endpoint.databricks_private_endpoint_ui,
    azurerm_private_endpoint.databricks_private_endpoint_web
  ]
}

resource "databricks_metastore_data_access" "metastore_data_access" {
  name         = "default-data-access"
  metastore_id = databricks_metastore.metastore.id

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.databricks_access_connector.id
  }
  is_default = true
}

resource "databricks_metastore_assignment" "metastore_assignment" {
  default_catalog_name = azurerm_databricks_workspace.databricks.name
  metastore_id         = databricks_metastore.metastore.id
  workspace_id         = azurerm_databricks_workspace.databricks.workspace_id
}
