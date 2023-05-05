resource "databricks_secret_scope" "platform_secret_scope" {
  name = "platform-secret-scope"

  backend_type = "AZURE_KEYVAULT"
  keyvault_metadata {
    dns_name    = var.key_vault_uri
    resource_id = var.key_vault_id
  }
}

resource "databricks_secret_acl" "secret_acl" {
  count      = var.databricks_admin_groupname != "" ? 1 : 0
  principal  = var.databricks_admin_groupname
  permission = "WRITE"
  scope      = databricks_secret_scope.platform_secret_scope.name
}
