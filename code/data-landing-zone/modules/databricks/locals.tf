locals {
  databricks = {
    enterprise_application_id = "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d"
    storage_account_name      = replace(var.workspace_name, "-", "")
  }
}
