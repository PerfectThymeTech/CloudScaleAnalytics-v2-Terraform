resource "azurerm_role_assignment" "client_roleassignment_key_vault" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.client_id
}
