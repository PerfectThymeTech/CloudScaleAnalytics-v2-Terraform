terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.56.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.6.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.18.0"
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
      purge_soft_delete_on_destroy               = false
      purge_soft_deleted_certificates_on_destroy = false
      purge_soft_deleted_keys_on_destroy         = false
      purge_soft_deleted_secrets_on_destroy      = false
      recover_soft_deleted_key_vaults            = true
      recover_soft_deleted_certificates          = true
      recover_soft_deleted_keys                  = true
      recover_soft_deleted_secrets               = true
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
  azure_environment           = "public"
  azure_workspace_resource_id = azurerm_databricks_workspace.databricks.id
  host                        = azurerm_databricks_workspace.databricks.workspace_url
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
