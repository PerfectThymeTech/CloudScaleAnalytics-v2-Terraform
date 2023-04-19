data "databricks_current_user" "current_user" {}

resource "databricks_grants" "grants_current_user" {
  catalog = var.unity_metastore_name
  grant {
    principal = data.databricks_current_user.current_user.user_name
    privileges = [
      "CREATE_CATALOG",
      "CREATE_EXTERNAL_LOCATION"
    ]
  }
}
