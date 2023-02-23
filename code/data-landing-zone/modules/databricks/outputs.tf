output "databricks_id" {
  value       = azurerm_databricks_workspace.databricks.id
  description = "Specifies the resource ID of the Databricks workspace."
  sensitive   = false
}

output "databricks_workspace_url" {
  value       = azurerm_databricks_workspace.databricks.workspace_url
  description = "Specifies the URL of the Databricks workspace."
  sensitive   = false
}

output "databricks_workspace_id" {
  value       = azurerm_databricks_workspace.databricks.workspace_id
  description = "Specifies the ID of the Databricks workspace."
  sensitive   = false
}

output "key_vault_id" {
  value = azurerm_key_vault.key_vault.id
  description = "Specifies the resource ID of the Key Vault."
  sensitive   = false
}

output "key_vault_uri" {
  value = azurerm_key_vault.key_vault.vault_uri
  description = "Specifies the uri of the Key Vault."
  sensitive   = false
}
