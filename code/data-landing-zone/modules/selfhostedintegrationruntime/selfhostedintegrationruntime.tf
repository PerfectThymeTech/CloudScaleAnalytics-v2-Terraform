data "azurerm_data_factory" "data_factory" {
  name                = local.data_factory.name
  resource_group_name = local.data_factory.resource_group_name
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "data_factory_shir" {
  name            = var.selfhostedintegrationruntime_name
  data_factory_id = data.azurerm_data_factory.data_factory.id
}
