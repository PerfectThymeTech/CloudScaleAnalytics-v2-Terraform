resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_subnet" {
  scope                = azapi_resource.subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity[0].principal_id
}

resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_container_raw" {
  scope                = one(azapi_resource.container_raw[*].id)
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity[0].principal_id
}

resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_container_enriched" {
  for_each             = azapi_resource.container_enriched
  scope                = azapi_resource.container_enriched[each.key].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity[0].principal_id
}

resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_container_curated" {
  scope                = azapi_resource.container_curated[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity[0].principal_id
}

resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_container_workspace" {
  scope                = azapi_resource.container_workspace[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity[0].principal_id
}
