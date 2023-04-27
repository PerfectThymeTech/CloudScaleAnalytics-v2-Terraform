module "shir_001" {
  source = "./modules/selfhostedintegrationruntime"

  location                          = var.location
  resource_group_name               = azurerm_resource_group.runtimes_rg.name
  tags                              = var.tags
  selfhostedintegrationruntime_name = "${local.prefix}-shir001"
  data_factory_id                   = azurerm_data_factory.data_factory.id
  subnet_id                         = azapi_resource.runtimes_subnet.id
  admin_username                    = var.admin_username
  shared_data_factory_ids           = []

  depends_on = [
    azurerm_private_endpoint.data_factory_private_endpoint_data_factory,
    azurerm_private_endpoint.data_factory_private_endpoint_portal
  ]
}
