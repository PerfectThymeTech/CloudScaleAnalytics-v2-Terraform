terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.14.3"
      configuration_aliases = [
        databricks.account
      ]
    }
  }
}
