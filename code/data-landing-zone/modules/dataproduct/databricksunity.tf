resource "databricks_storage_credential" "storage_credential" {
  metastore_id = var.unity_metastore_id
  name         = local.names.databricks_storage_credential

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.databricks_access_connector.id
  }
  comment = "Managed identity credential for ${var.data_product_name} Data Product"
}

resource "databricks_external_location" "external_location" {
  metastore_id = var.unity_metastore_id
  name         = local.names.databricks_external_location

  comment         = "Default Storage for ${var.data_product_name} Data Product"
  credential_name = databricks_storage_credential.storage_credential.name
  skip_validation = false
  url             = local.databricks_catalog_storage_root
}

resource "databricks_catalog" "catalog" {
  metastore_id = var.unity_metastore_id
  name         = local.names.databricks_catalog

  comment       = "Data Product Catalog - ${var.data_product_name}"
  force_destroy = false
  properties = {
    purpose = "Data Product Catalog - ${var.data_product_name}"
  }
  share_name   = var.unity_metastore_id
  storage_root = local.databricks_catalog_storage_root

  depends_on = [
    databricks_external_location.external_location
  ]
}
