resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = "${local.prefix}-uai001"
  location            = var.location
  resource_group_name = azurerm_resource_group.automation_rg.name
  tags                = var.tags
}
