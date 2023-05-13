terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "1.5.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.15.0"
      configuration_aliases = [
        databricks.automation,
        databricks.experimentation,
      ]
    }
  }
}
