resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  count               = var.user_assigned_identity_enabled ? 1 : 0
  name                = local.names.user_assigned_identity
  location            = var.location
  resource_group_name = azurerm_resource_group.data_product_rg.name
  tags                = var.tags
}
