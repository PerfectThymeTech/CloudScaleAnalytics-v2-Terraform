data "databricks_current_user" "current" {}

resource "databricks_grants" "sandbox" {
  catalog = var.unity_metastore_id
  grant {
    principal = data.databricks_current_user.current.user_name
    privileges = [
      "CREATE_CATALOG",
      "CREATE_EXTERNAL_LOCATION"
    ]
  }
}
