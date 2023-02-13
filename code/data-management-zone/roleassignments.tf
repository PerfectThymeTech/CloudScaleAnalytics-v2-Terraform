resource "azurerm_role_assignment" "purview_roleassignment_key_vault" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_purview_account.purview.identity[0].principal_id
}

resource "azurerm_role_assignment" "purview_roleassignment_eventhub_hook" {
  scope                = azurerm_eventhub.eventhub_hook.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = azurerm_purview_account.purview.identity[0].principal_id
}

resource "azurerm_role_assignment" "purview_roleassignment_eventhub_notification" {
  scope                = azurerm_eventhub.eventhub_notification.id
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = azurerm_purview_account.purview.identity[0].principal_id
}

resource "azurerm_role_assignment" "user_assigned_identity_roleassignment_governance_rg" {
  scope                = azurerm_purview_account.purview.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}
