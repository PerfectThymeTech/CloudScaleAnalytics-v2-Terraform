# data "databricks_group" "security_group" {
#   count        = var.databricks_enabled && var.unity_catalog_configurations.enabled && var.unity_catalog_configurations.group_name != "" ? 1 : 0
#   display_name = var.unity_catalog_configurations.group_name
# }

resource "databricks_grants" "grants_experimentation_catalog" {
  count   = var.databricks_enabled && var.unity_catalog_configurations.enabled && var.databricks_experimentation && var.unity_catalog_configurations.group_name != "" ? 1 : 0
  catalog = one(databricks_catalog.experimentation_catalog[*].name)
  grant {
    principal  = var.unity_catalog_configurations.group_name
    privileges = ["ALL_PRIVILEGES"]
  }
}

resource "databricks_grants" "grants_automation_catalog" {
  count   = var.databricks_enabled && var.unity_catalog_configurations.enabled && !var.databricks_experimentation && var.unity_catalog_configurations.group_name != "" ? 1 : 0
  catalog = one(databricks_catalog.automation_catalog[*].name)
  grant {
    principal  = var.unity_catalog_configurations.group_name
    privileges = ["ALL_PRIVILEGES"]
  }
}
