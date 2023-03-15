resource "azurerm_databricks_access_connector" "databricks_access_connector" {
  name                = "${local.prefix}-dbac001"
  location            = var.location
  resource_group_name = azurerm_resource_group.unity_rg.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
}
