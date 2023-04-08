variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "data_product_name" {
  description = "Specifies the name of the Databricks workspace."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.workspace_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(any)
  sensitive   = false
}

variable "network_enabled" {
  description = "Specifies whether network resources should be deployed for the data product."
  type        = bool
  sensitive   = false
  default     = true
}

variable "vnet_id" {
  description = "Specifies the resource ID of the Vnet used for the Data Landing Zone"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.vnet_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "nsg_id" {
  description = "Specifies the resource ID of the default network security group for the Data Landing Zone"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.nsg_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "route_table_id" {
  description = "Specifies the resource ID of the default route table for the Data Landing Zone"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.route_table_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "subnet_cidr_range" {
  description = "Specifies the subnet cidr range for the data product."
  type        = bool
  sensitive   = false
  default     = true
}

variable "containers_enabled" {
  description = "Specifies which containers should be deployed across the data lakes."
  type = object({
    raw       = optional(bool, false)
    enriched  = optional(bool, false)
    curated   = optional(bool, false)
    workspace = optional(bool, false)
  })
  sensitive = false
}

variable "datalake_raw_id" {
  description = "Specifies the resource id of the raw data lake."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.datalake_raw_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "datalake_enriched_id" {
  description = "Specifies the resource id of the raw data lake."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.datalake_enriched_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "datalake_curated_id" {
  description = "Specifies the resource id of the raw data lake."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.datalake_curated_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "datalake_workspace_id" {
  description = "Specifies the resource id of the raw data lake."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.datalake_workspace_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "user_assigned_identity_enabled" {
  description = "Specifies whether the user assigned identity should be deployed for the data product."
  type        = bool
  sensitive   = false
  default     = false
}
