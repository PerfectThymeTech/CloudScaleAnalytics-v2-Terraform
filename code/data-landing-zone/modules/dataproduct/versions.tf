terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "1.6.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.16.1"
      configuration_aliases = [
        databricks.automation,
        databricks.experimentation,
      ]
    }
  }
}
