terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "1.6.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.17.0"
      configuration_aliases = [
        databricks.automation,
        databricks.experimentation,
      ]
    }
  }
}
