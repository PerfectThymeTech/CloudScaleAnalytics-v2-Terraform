terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "1.5.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.14.3"
    }
  }
}
