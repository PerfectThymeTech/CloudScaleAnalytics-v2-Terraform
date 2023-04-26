resource "azurerm_resource_group" "data_product_rg" {
  name     = local.names.resource_group
  location = var.location
  tags     = var.tags
}
