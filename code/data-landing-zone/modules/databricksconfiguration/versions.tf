terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.19.0"
      configuration_aliases = [
        databricks.account
      ]
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}
