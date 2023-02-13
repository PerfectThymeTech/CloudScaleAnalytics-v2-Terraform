variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
}

variable "environment" {
  description = "Specifies the environment of the deployment."
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "tst", "prd"], var.environment)
    error_message = "Please use an allowed value: \"dev\", \"tst\" or \"prd\"."
  }
}

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment."
  type        = string
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(any)
}

variable "vnet_id" {
  description = "Specifies the resource ID of the Vnet used for the Data Management Zone"
  type        = string
  validation {
    condition     = length(split("/", var.vnet_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "nsg_id" {
  description = "Specifies the resource ID of the default network security group for the Data Management Zone"
  type        = string
  validation {
    condition     = length(split("/", var.nsg_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "route_table_id" {
  description = "Specifies the resource ID of the default route table for the Data Management Zone"
  type        = string
  validation {
    condition     = length(split("/", var.route_table_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

# variable "services_subnet_address_prefix" {
#   description = "Specifies the resource ID of the Vnet used for the Data Management Zone"
#   type = string
#   validation {
#     condition = length(split("/", var.vnet_id)) == 9
#     error_message = "Please specify a valid resource ID for a virtual network."
#   }
# }

variable "private_dns_zone_id_eventhub_namespace" {
  description = "Specifies the resource ID of the private DNS zone for the EventHub namespace."
  type        = string
  validation {
    condition     = var.private_dns_zone_id_eventhub_namespace == "" || (length(split("/", var.private_dns_zone_id_eventhub_namespace)) == 9 && endswith(var.private_dns_zone_id_eventhub_namespace, "privatelink.servicebus.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_purview_account" {
  description = "Specifies the resource ID of the private DNS zone for the Purview account."
  type        = string
  validation {
    condition     = var.private_dns_zone_id_purview_account == "" || (length(split("/", var.private_dns_zone_id_purview_account)) == 9 && endswith(var.private_dns_zone_id_purview_account, "privatelink.purview.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_purview_portal" {
  description = "Specifies the resource ID of the private DNS zone for the Purview portal."
  type        = string
  validation {
    condition     = var.private_dns_zone_id_purview_portal == "" || (length(split("/", var.private_dns_zone_id_purview_portal)) == 9 && endswith(var.private_dns_zone_id_purview_portal, "privatelink.purviewstudio.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_purview_blob" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints."
  type        = string
  validation {
    condition     = var.private_dns_zone_id_purview_blob == "" || (length(split("/", var.private_dns_zone_id_purview_blob)) == 9 && endswith(var.private_dns_zone_id_purview_blob, "privatelink.blob.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_purview_queue" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints."
  type        = string
  validation {
    condition     = var.private_dns_zone_id_purview_queue == "" || (length(split("/", var.private_dns_zone_id_purview_queue)) == 9 && endswith(var.private_dns_zone_id_purview_queue, "privatelink.queue.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}
