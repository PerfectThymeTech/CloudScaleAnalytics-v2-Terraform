resource "azurerm_databricks_access_connector" "databricks_access_connector" {
  count               = var.databricks_enabled && var.unity_catalog_configurations.enabled ? 1 : 0
  name                = local.names.databricks_access_connector
  location            = var.location
  resource_group_name = azurerm_resource_group.data_product_rg.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
}
