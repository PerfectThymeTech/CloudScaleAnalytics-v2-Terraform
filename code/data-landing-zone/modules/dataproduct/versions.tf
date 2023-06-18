terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "1.7.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.16.0"
      configuration_aliases = [
        databricks.automation,
        databricks.experimentation,
      ]
    }
  }
}
