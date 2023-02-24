locals {
  databricks = {
    resource_group_name = split("/", var.databricks_id)[4]
    name                = split("/", var.databricks_id)[8]
  }
}
