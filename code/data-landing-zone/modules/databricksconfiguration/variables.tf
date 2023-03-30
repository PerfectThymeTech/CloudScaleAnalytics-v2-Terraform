data "azurerm_client_config" "current" {
}

variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(any)
  sensitive   = false
}

variable "key_vault_id" {
  description = "Specifies the resource ID of the key vault used for the platform."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.key_vault_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "key_vault_uri" {
  description = "Specifies the uri of the key vault used for the platform."
  type        = string
  sensitive   = false
  validation {
    condition     = endswith(var.key_vault_uri, "vault.azure.net/")
    error_message = "Please specify a valid uri."
  }
}

variable "client_id_secret_name" {
  description = "Specifies the AAD client id secret name in the key vault."
  type        = string
  sensitive   = false
  validation {
    condition     = var.client_id_secret_name == "" || length(var.client_id_secret_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "client_secret_secret_name" {
  description = "Specifies the AAD client secret secret-name in the key vault."
  type        = string
  sensitive   = false
  validation {
    condition     = var.client_id_secret_name == "" || length(var.client_secret_secret_name) >= 2
    error_message = "Please specify a valid name."
  }
}
