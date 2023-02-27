resource "databricks_metastore" "metastore" {
  name = "${var.company_name}-${title(var.location)}"

  delta_sharing_organization_name                   = var.company_name
  delta_sharing_recipient_token_lifetime_in_seconds = 0
  delta_sharing_scope                               = "INTERNAL"
  owner                                             = data.azurerm_client_config.current.client_id
  storage_root                                      = "abfss://${var.storage_container_name}@${var.storage_name}.dfs.core.windows.net/"
  force_destroy = true
}

resource "databricks_metastore_data_access" "metastore_data_access" {
  name         = "DefaultDataAccess"
  metastore_id = databricks_metastore.metastore.id

  azure_managed_identity {
    access_connector_id = var.databricks_access_connector_id
  }
  is_default = true
}

resource "databricks_metastore_assignment" "metastore_assignment" {
  default_catalog_name = local.databricks.name
  metastore_id         = databricks_metastore.metastore.id
  workspace_id         = var.databricks_workspace_id
}
