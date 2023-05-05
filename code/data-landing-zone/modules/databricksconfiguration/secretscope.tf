resource "databricks_secret_scope" "platform_secret_scope" {
  name = "platform-secret-scope"

  backend_type = "AZURE_KEYVAULT"
  keyvault_metadata {
    dns_name    = var.key_vault_uri
    resource_id = var.key_vault_id
  }
}

data "databricks_current_user" "current" {}

data "databricks_group" "group" {
  count        = var.databricks_admin_groupname != "" ? 1 : 0
  display_name = var.databricks_admin_groupname

  provider = databricks.account
}

resource "databricks_mws_permission_assignment" "permission_assignment" {
  workspace_id = var.databricks_workspace_id
  principal_id = one(data.databricks_group.group[*].id)
  permissions = [
    "ADMIN"
  ]

  provider = databricks.account
}

resource "databricks_secret_acl" "secret_acl" {
  count      = var.databricks_admin_groupname != "" ? 1 : 0
  principal  = one(data.databricks_group.group[*].display_name)
  permission = "MANAGE"
  scope      = databricks_secret_scope.platform_secret_scope.name

  depends_on = [
    databricks_mws_permission_assignment.permission_assignment
  ]
}
