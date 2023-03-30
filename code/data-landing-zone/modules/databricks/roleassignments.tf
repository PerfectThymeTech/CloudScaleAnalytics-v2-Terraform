resource "azurerm_role_assignment" "client_roleassignment_key_vault" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "databricks_roleassignment_key_vault" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azuread_service_principal.databricks.object_id
}
