data "azurerm_data_factory" "shared_data_factories" {
  for_each            = toset(local.shared_data_factories)
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "data_factory_shir_shared" {
  for_each        = data.azurerm_data_factory.shared_data_factories
  name            = data.azurerm_data_factory.shared_data_factories[each.key].name
  data_factory_id = data.azurerm_data_factory.shared_data_factories[each.key].id

  description = "Shared Self-Hosted Integration runtime ${var.selfhostedintegrationruntime_name}"
  rbac_authorization {
    resource_id = azurerm_data_factory_integration_runtime_self_hosted.data_factory_shir.id
  }

  depends_on = [
    azurerm_role_assignment.data_factory_roleassignment_data_factory
  ]
}
