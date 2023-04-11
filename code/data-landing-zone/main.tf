terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.51.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.4.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.14.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.36.0"
    }
  }

  backend "azurerm" {
    environment          = "public"
    resource_group_name  = "mycrp-prd-cicd"
    storage_account_name = "mycrpprdstg001"
    container_name       = "data-landing-zone"
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
    application_insights {
      disable_generated_rule = false
    }
    cognitive_account {
      purge_soft_delete_on_destroy = true
    }
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
    log_analytics_workspace {
      permanently_delete_on_destroy = true
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

provider "azuread" {
  tenant_id = data.azurerm_client_config.current.tenant_id
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

data "azurerm_client_config" "current" {}

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
