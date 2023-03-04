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
