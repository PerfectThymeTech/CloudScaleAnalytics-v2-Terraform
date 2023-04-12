resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_resource_group" {
  count                = one(data.azuread_group.security_group[*].object_id) != null ? 1 : 0
  scope                = azurerm_resource_group.data_product_rg.id
  role_definition_name = "Contributor"
  principal_id         = one(data.azuread_group.security_group[*].object_id)
}

resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_subnet" {
  count                = one(azapi_resource.subnet[*].id) != null && one(data.azuread_group.security_group[*].object_id) != null ? 1 : 0
  scope                = one(azapi_resource.subnet[*].id)
  role_definition_name = "Network Contributor"
  principal_id         = one(data.azuread_group.security_group[*].object_id)
}

resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_container_raw" {
  count                = one(azapi_resource.container_raw[*].id) != null && one(data.azuread_group.security_group[*].object_id) != null ? 1 : 0
  scope                = one(azapi_resource.container_raw[*].id)
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = one(data.azuread_group.security_group[*].object_id)
}

resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_container_enriched" {
  count                = one(azapi_resource.container_enriched[*].id) && one(data.azuread_group.security_group[*].object_id) != null ? 1 : 0
  scope                = one(azapi_resource.container_enriched[*].id)
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = one(data.azuread_group.security_group[*].object_id)
}

resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_container_curated" {
  count                = one(azapi_resource.container_curated[*].id) && one(data.azuread_group.security_group[*].object_id) != null ? 1 : 0
  scope                = one(azapi_resource.container_curated[*].id)
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = one(data.azuread_group.security_group[*].object_id)
}

resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_container_workspace" {
  count                = one(azapi_resource.container_workspace[*].id) && one(data.azuread_group.security_group[*].object_id) != null ? 1 : 0
  scope                = one(azapi_resource.container_workspace[*].id)
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = one(data.azuread_group.security_group[*].object_id)
}
