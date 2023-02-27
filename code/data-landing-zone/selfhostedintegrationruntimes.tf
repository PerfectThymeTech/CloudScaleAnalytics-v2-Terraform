module "shir_001" {
  source = "./modules/selfhostedintegrationruntime"

  location                          = var.location
  resource_group_name               = azurerm_resource_group.storage_rg.name
  tags                              = var.tags
  selfhostedintegrationruntime_name = "${local.prefix}-shir001"
  data_factory_id                   = azurerm_data_factory.data_factory.id
  subnet_id                         = azurerm_subnet.runtimes_subnet.id
  admin_username                    = var.admin_username
  admin_password                    = var.admin_password
}