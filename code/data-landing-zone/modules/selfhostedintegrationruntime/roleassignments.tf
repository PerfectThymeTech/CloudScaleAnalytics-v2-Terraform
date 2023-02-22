resource "azurerm_role_assignment" "data_factory_roleassignment_data_factory" {
  for_each             = data.azurerm_data_factory.shared_data_factories
  scope                = data.azurerm_data_factory.data_factory.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_data_factory.shared_data_factories[each.key].identity[0].principal_id
}
