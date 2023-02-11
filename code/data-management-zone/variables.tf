variable "location" {
  description = "Specifies the location for all Azure resources."
  type = string
}

variable "environment" {
  description = "Specifies the environment of the deployment."
  type = string
  default = "dev"
  validation {
    condition = contains(["dev", "tst", "prd"], var.environment)
    error_message = "Please use an allowed value: \"dev\", \"tst\" or \"prd\"."
  }
}

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment."
  type = string
  validation {
    condition = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type = map
}
