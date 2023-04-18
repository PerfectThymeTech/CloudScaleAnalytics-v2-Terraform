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
    condition     = can(regex("^[a-zA-Z0-9-]{2,30}$", var.data_product_name))
    error_message = "Please specify a valid data product name. The name '${var.data_product_name}' is invalid."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

variable "network_enabled" {
  description = "Specifies whether network resources should be deployed for the data product."
  type        = bool
  sensitive   = false
  default     = false
  validation {
    condition     = var.network_enabled == true || var.network_enabled == false
    error_message = "Please specify a valid value for 'network.enabled'. 'network.enabled' needs to be a boolean."
  }
}

variable "vnet_id" {
  description = "Specifies the resource ID of the Vnet used for the Data Landing Zone"
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.vnet_id == "" || length(split("/", var.vnet_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "nsg_id" {
  description = "Specifies the resource ID of the default network security group for the Data Landing Zone"
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.nsg_id == "" || length(split("/", var.nsg_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "route_table_id" {
  description = "Specifies the resource ID of the default route table for the Data Landing Zone"
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.route_table_id == "" || length(split("/", var.route_table_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "subnet_cidr_range" {
  description = "Specifies the subnet cidr range for the data product."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.subnet_cidr_range == "" || try(cidrnetmask(var.subnet_cidr_range), "invalid") != "invalid"
    error_message = "Please specify a valid subnet CIDR range. Subnet CIDR range specified in 'network.subnet_cidr_range' must be valid and within the range of teh virtual network."
  }
}

variable "private_dns_zone_id_key_vault" {
  description = "Specifies the resource ID of the private DNS zone for Azure Key Vault endpoints."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_key_vault == "" || (length(split("/", var.private_dns_zone_id_key_vault)) == 9 && endswith(var.private_dns_zone_id_key_vault, "privatelink.vaultcore.azure.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "identity_enabled" {
  description = "Specifies whether identity resources should be deployed for the data product."
  type        = bool
  sensitive   = false
  default     = false
  validation {
    condition     = var.identity_enabled == true || var.identity_enabled == false
    error_message = "Please specify a valid value for 'identity.enabled'. 'identity.enabled' needs to be a boolean."
  }
}

variable "security_group_display_name" {
  description = "Specifies the Azure AD security group display name."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.security_group_display_name == "" || length(var.security_group_display_name) >= 2
    error_message = "Please specify a valid Azure AD security group display name for 'identity.security_group_display_name'."
  }
}

variable "user_assigned_identity_enabled" {
  description = "Specifies whether the user assigned identity should be deployed for the data product."
  type        = bool
  sensitive   = false
  default     = false
  validation {
    condition     = var.user_assigned_identity_enabled == true || var.user_assigned_identity_enabled == false
    error_message = "Please specify a valid value for 'settings.user_assigned_identity_enabled'. 'settings.user_assigned_identity_enabled' needs to be a boolean."
  }
}

variable "service_principal_enabled" {
  description = "Specifies whether the user assigned identity should be deployed for the data product."
  type        = bool
  sensitive   = false
  default     = false
  validation {
    condition     = var.service_principal_enabled == true || var.service_principal_enabled == false
    error_message = "Please specify a valid value for 'settings.service_principal_enabled'. 'settings.service_principal_enabled' needs to be a boolean."
  }
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
  validation {
    condition = alltrue([
      var.containers_enabled.raw == true || var.containers_enabled.raw == false,
      var.containers_enabled.enriched == true || var.containers_enabled.enriched == false,
      var.containers_enabled.curated == true || var.containers_enabled.curated == false,
      var.containers_enabled.workspace == true || var.containers_enabled.workspace == false,
    ])
    error_message = "Please specify a valid value for 'network.enabled'. 'network.enabled' needs to be a boolean."
  }
}

variable "datalake_raw_id" {
  description = "Specifies the resource id of the raw data lake."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.datalake_raw_id == "" || length(split("/", var.datalake_raw_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "datalake_enriched_id" {
  description = "Specifies the resource id of the raw data lake."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.datalake_enriched_id == "" || length(split("/", var.datalake_enriched_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "datalake_curated_id" {
  description = "Specifies the resource id of the raw data lake."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.datalake_curated_id == "" || length(split("/", var.datalake_curated_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "datalake_workspace_id" {
  description = "Specifies the resource id of the raw data lake."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.datalake_workspace_id == "" || length(split("/", var.datalake_workspace_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "unity_metastore_id" {
  description = "Specifies the id of the Databricks Unity metastore."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.unity_metastore_id == "" || length(var.unity_metastore_id) >= 2
    error_message = "Please specify a valid name."
  }
}
