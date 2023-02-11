resource "azurerm_purview_account" "purview" {
  name = "${local.prefix}-purview001"
  location = var.location
  resource_group_name = azurerm_resource_group.governance_rg.name
  tags = var.tags
  identity {
    type = "SystemAssigned"
  }
  managed_resource_group_name = "${purview.name}-rg"
  public_network_enabled = false
}