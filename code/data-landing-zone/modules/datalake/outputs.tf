output "datalake_id" {
  value       = azurerm_storage_account.datalake.id
  description = "Specifies the resource ID of the datalake."
  sensitive   = false
}
