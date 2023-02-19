resource "azurerm_data_factory_integration_runtime_self_hosted" "data_factory_shir" {
  name            = var.selfhostedintegrationruntime_name
  data_factory_id = var.data_factory_id
}
