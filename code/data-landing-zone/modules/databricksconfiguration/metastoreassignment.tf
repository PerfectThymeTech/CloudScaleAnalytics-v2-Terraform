resource "databricks_metastore_assignment" "metastore_assignment" {
  count                = var.unity_metastore_name != "" && var.unity_metastore_id != "" ? 1 : 0
  default_catalog_name = var.unity_metastore_name
  metastore_id         = var.unity_metastore_id
  workspace_id         = var.databricks_workspace_id
}
