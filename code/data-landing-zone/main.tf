terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.43.0"
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
    resource_group_name  = "terraform"
    storage_account_name = "terraformptt001"
    container_name       = "tfstate"
    key                  = "terraform.data-landing-zone.tfstate"
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
  alias                       = "automation"
  azure_environment           = "public"
  azure_workspace_resource_id = module.databricks_automation.databricks_id
  host                        = module.databricks_automation.databricks_workspace_url
}

provider "databricks" {
  alias                       = "experimentation"
  azure_environment           = "public"
  azure_workspace_resource_id = module.databricks_experimentation.databricks_id
  host                        = module.databricks_experimentation.databricks_workspace_url
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "management_rg" {
  name     = "${local.prefix}-mgmt-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "storage_rg" {
  name     = "${local.prefix}-storage-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "runtimes_rg" {
  name     = "${local.prefix}-runtimes-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "shared_app_aut_rg" {
  name     = "${local.prefix}-shared-app-aut-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "shared_app_exp_rg" {
  name     = "${local.prefix}-shared-app-exp-rg"
  location = var.location
  tags     = var.tags
}
