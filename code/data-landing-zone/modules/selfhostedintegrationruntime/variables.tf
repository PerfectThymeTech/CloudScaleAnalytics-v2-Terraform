variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "selfhostedintegrationruntime_name" {
  description = "Specifies the name of the Self-hosted integration runtime."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.selfhostedintegrationruntime_name) >= 2
    error_message = "Please specify a valid name."
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

variable "data_factory_id" {
  description = "Specifies the resource ID of the Azure Data Factory."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.data_factory_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "subnet_id" {
  description = "Specifies the resource ID of the subnet used for the SHIR."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.subnet_id)) == 11
    error_message = "Please specify a valid resource ID."
  }
}

variable "admin_username" {
  description = "Specifies the admin username of the VMMS of the Self-hosted integration runtime."
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Specifies the admin password of the VMMS of the Self-hosted integration runtime."
  type        = string
  sensitive   = true
}

variable "shared_data_factory_ids" {
  description = "Specifies the resource IDs of the Azure Data Factories with which the SHIR should be shared."
  type        = list(string)
  sensitive   = true
}
