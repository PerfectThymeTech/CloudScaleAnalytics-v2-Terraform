variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
}

variable "selfhostedintegrationruntime_name" {
  description = "Specifies the name of the Self-hosted integration runtime."
  type        = string
  validation {
    condition     = length(var.selfhostedintegrationruntime_name) >= 2
    error_message = "Please specify a valid name."
  }
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
