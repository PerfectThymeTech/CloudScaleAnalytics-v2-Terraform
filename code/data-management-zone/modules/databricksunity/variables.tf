data "azurerm_client_config" "current" {
}

variable "company_name" {
  description = "Specifies the name of the company."
  type        = string
  sensitive   = false
}

variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "databricks_access_connector_id" {
  description = "Specifies the resource id of the Azure Databricks Access Connector id."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.databricks_access_connector_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "databricks_id" {
  description = "Specifies the resource id of the Azure Databricks workspace."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.databricks_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "storage_name" {
  description = "Specifies the name of the Datalake."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.storage_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "storage_container_name" {
  description = "Specifies the name of the Datalake file system."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.storage_container_name) >= 2
    error_message = "Please specify a valid name."
  }
}
