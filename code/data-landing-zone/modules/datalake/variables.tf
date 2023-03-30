data "azurerm_client_config" "current" {
}

variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "datalake_name" {
  description = "Specifies the name of the ADLS Gen2 account."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.datalake_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "datalake_filesystem_names" {
  description = "Specifies the names of the ADLS Gen2 containers."
  type        = list(string)
  sensitive   = false
}

variable "datalake_replication_type" {
  description = "Specifies the replication type of the ADLS Gen2 account."
  type        = string
  sensitive   = false
  default     = "ZRS"
  validation {
    condition     = contains(["ZRS", "GZRS"], var.datalake_replication_type)
    error_message = "Please specify a valid replication type."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(any)
  sensitive   = false
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  sensitive   = false
}

variable "subnet_id" {
  description = "Specifies the resource ID of the subnet used for the datalake."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.subnet_id)) == 11
    error_message = "Please specify a valid resource ID."
  }
}

variable "enable_queue_private_endpoint" {
  description = "Specifies whether to deploy the queue private endpoint for Azure Storage."
  type        = bool
  sensitive   = false
  default     = false
}

variable "enable_table_private_endpoint" {
  description = "Specifies whether to deploy the table private endpoint for Azure Storage."
  type        = bool
  sensitive   = false
  default     = false
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

variable "private_dns_zone_id_dfs" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage dfs endpoints."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_dfs == "" || (length(split("/", var.private_dns_zone_id_dfs)) == 9 && endswith(var.private_dns_zone_id_dfs, "privatelink.dfs.core.windows.net"))
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

variable "private_dns_zone_id_table" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage table endpoints."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_table == "" || (length(split("/", var.private_dns_zone_id_table)) == 9 && endswith(var.private_dns_zone_id_table, "privatelink.table.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "data_platform_subscription_ids" {
  description = "Specifies the list of subscription IDs of your data platform."
  type        = list(string)
  sensitive   = false
}
