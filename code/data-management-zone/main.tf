terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.10.0"
    }
  }

  backend "azurerm" {
    environment          = "public"
    resource_group_name  = "mycrp-prd-cicd"
    storage_account_name = "mycrpprdstg001"
    container_name       = "data-management-zone"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  disable_correlation_request_id = false
  environment                    = "public"
  skip_provider_registration     = false
  storage_use_azuread            = true
  use_oidc                       = true

  features {
    key_vault {
      recover_soft_deleted_key_vaults   = true
      recover_soft_deleted_certificates = true
      recover_soft_deleted_keys         = true
      recover_soft_deleted_secrets      = true
    }
    network {
      relaxed_locking = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

provider "azapi" {
  default_location               = var.location
  default_tags                   = var.tags
  disable_correlation_request_id = false
  environment                    = "public"
  skip_provider_registration     = false
  use_oidc                       = true
}

provider "databricks" {
  auth_type                   = "azure-cli"
  azure_environment           = "public"
  azure_use_msi               = false
  azure_workspace_resource_id = module.databricks_consumption.databricks_id
  host                        = module.databricks_consumption.databricks_workspace_url
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "governance_rg" {
  name     = "${local.prefix}-governance-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "unity_rg" {
  name     = "${local.prefix}-unity-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "container_rg" {
  name     = "${local.prefix}-container-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "consumption_rg" {
  name     = "${local.prefix}-consumption-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "automation_rg" {
  name     = "${local.prefix}-automation-rg"
  location = var.location
  tags     = var.tags
}
