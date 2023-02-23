variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "environment" {
  description = "Specifies the environment of the deployment."
  type        = string
  sensitive   = false
  default     = "dev"
  validation {
    condition     = contains(["dev", "tst", "prd"], var.environment)
    error_message = "Please use an allowed value: \"dev\", \"tst\" or \"prd\"."
  }
}

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(any)
  sensitive   = false
}

variable "vnet_id" {
  description = "Specifies the resource ID of the Vnet used for the Data Management Zone"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.vnet_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "nsg_id" {
  description = "Specifies the resource ID of the default network security group for the Data Management Zone"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.nsg_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "route_table_id" {
  description = "Specifies the resource ID of the default route table for the Data Management Zone"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.route_table_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "private_dns_zone_id_namespace" {
  description = "Specifies the resource ID of the private DNS zone for the EventHub namespace."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_namespace == "" || (length(split("/", var.private_dns_zone_id_namespace)) == 9 && endswith(var.private_dns_zone_id_namespace, "privatelink.servicebus.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_purview_account" {
  description = "Specifies the resource ID of the private DNS zone for the Purview account."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_purview_account == "" || (length(split("/", var.private_dns_zone_id_purview_account)) == 9 && endswith(var.private_dns_zone_id_purview_account, "privatelink.purview.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_purview_portal" {
  description = "Specifies the resource ID of the private DNS zone for the Purview portal."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_purview_portal == "" || (length(split("/", var.private_dns_zone_id_purview_portal)) == 9 && endswith(var.private_dns_zone_id_purview_portal, "privatelink.purviewstudio.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_blob" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_blob == "" || (length(split("/", var.private_dns_zone_id_blob)) == 9 && endswith(var.private_dns_zone_id_blob, "privatelink.blob.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_queue" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_queue == "" || (length(split("/", var.private_dns_zone_id_queue)) == 9 && endswith(var.private_dns_zone_id_queue, "privatelink.queue.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_container_registry" {
  description = "Specifies the resource ID of the private DNS zone for Azure Container Registry."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_container_registry == "" || (length(split("/", var.private_dns_zone_id_container_registry)) == 9 && endswith(var.private_dns_zone_id_container_registry, "privatelink.azurecr.io"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_synapse_portal" {
  description = "Specifies the resource ID of the private DNS zone for Synapse PL Hub."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_synapse_portal == "" || (length(split("/", var.private_dns_zone_id_synapse_portal)) == 9 && endswith(var.private_dns_zone_id_synapse_portal, "privatelink.azuresynapse.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_key_vault" {
  description = "Specifies the resource ID of the private DNS zone for Azure Key Vault."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_key_vault == "" || (length(split("/", var.private_dns_zone_id_key_vault)) == 9 && endswith(var.private_dns_zone_id_key_vault, "privatelink.vaultcore.azure.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_databricks" {
  description = "Specifies the resource ID of the private DNS zone for Azure Databricks UI endpoints."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_databricks == "" || (length(split("/", var.private_dns_zone_id_databricks)) == 9 && endswith(var.private_dns_zone_id_databricks, "privatelink.azuredatabricks.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "purview_root_collection_admins" {
  description = "Specifies the list of user object IDs that are assigned as collection admin to the root collection in Purview."
  type        = list(string)
  sensitive   = false
}
