resource "azurerm_data_factory" "data_factory_runtimes" {
  name = "${local.prefix}-adf001"
  location = var.location
  resource_group_name = azurerm_resource_group.runtimes_rg
  tags = var.tags
  identity {
    type = "SystemAssigned"
  }
  
  managed_virtual_network_enabled = true
  public_network_enabled = false
  purview_id = var.purview_id
}
