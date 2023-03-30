resource "databricks_secret_scope" "platform_secret_scope" {
  name = "platform-secret-scope"

  backend_type = "AZURE_KEYVAULT"
  keyvault_metadata {
    dns_name    = var.key_vault_uri
    resource_id = var.key_vault_id
  }
}
