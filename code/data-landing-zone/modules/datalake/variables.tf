variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
}

variable "datalake_name" {
  description = "Specifies the name of the ADLS Gen2 account."
  type        = string
  validation {
    condition     = length(var.datalake_name) >= 2
    error_message = "Specifies the name of the ADLS Gen2 account."
  }
}

variable "datalake_filesystem_names" {
  description = "Specifies the names of the ADLS Gen2 containers."
  type        = list(string)
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(any)
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "subnet_id" {
  description = "Specifies the resource ID of the subnet used for the datalake."
  type        = string
  validation {
    condition     = length(split("/", var.vnet_id)) == 11
    error_message = "Please specify a valid resource ID."
  }
}

variable "private_dns_zone_id_blob" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints."
  type        = string
  validation {
    condition     = var.private_dns_zone_id_blob == "" || (length(split("/", var.private_dns_zone_id_blob)) == 9 && endswith(var.private_dns_zone_id_blob, "privatelink.blob.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_dfs" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage dfs endpoints."
  type        = string
  validation {
    condition     = var.private_dns_zone_id_dfs == "" || (length(split("/", var.private_dns_zone_id_dfs)) == 9 && endswith(var.private_dns_zone_id_dfs, "privatelink.dfs.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}
