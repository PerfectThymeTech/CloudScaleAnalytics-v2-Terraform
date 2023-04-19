data "azurerm_storage_account" "datalake_raw" {
  name                = local.datalake_raw.name
  resource_group_name = local.datalake_raw.resource_group_name
}

resource "azapi_resource" "container_raw" {
  count     = var.containers_enabled.raw ? 1 : 0
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01"
  name      = local.names.container_raw
  parent_id = "${data.azurerm_storage_account.datalake_raw.id}/blobServices/default"

  body = jsonencode({
    properties = {
      publicAccess = "None"
      metadata     = {}
    }
  })
}

data "azurerm_storage_account" "datalake_enriched" {
  name                = local.datalake_enriched.name
  resource_group_name = local.datalake_enriched.resource_group_name
}

resource "azapi_resource" "container_enriched" {
  count     = var.containers_enabled.enriched ? 1 : 0
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01"
  name      = local.names.container_enriched
  parent_id = "${data.azurerm_storage_account.datalake_enriched.id}/blobServices/default"

  body = jsonencode({
    properties = {
      publicAccess = "None"
      metadata     = {}
    }
  })
}

data "azurerm_storage_account" "datalake_curated" {
  name                = local.datalake_curated.name
  resource_group_name = local.datalake_curated.resource_group_name
}

resource "azapi_resource" "container_curated" {
  count     = var.containers_enabled.curated ? 1 : 0
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01"
  name      = local.names.container_curated
  parent_id = "${data.azurerm_storage_account.datalake_curated.id}/blobServices/default"

  body = jsonencode({
    properties = {
      publicAccess = "None"
      metadata     = {}
    }
  })
}

data "azurerm_storage_account" "datalake_workspace" {
  name                = local.datalake_workspace.name
  resource_group_name = local.datalake_workspace.resource_group_name
}

resource "azapi_resource" "container_workspace" {
  count     = var.containers_enabled.workspace ? 1 : 0
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01"
  name      = local.names.container_workspace
  parent_id = "${data.azurerm_storage_account.datalake_workspace.id}/blobServices/default"

  body = jsonencode({
    properties = {
      publicAccess = "None"
      metadata     = {}
    }
  })
}
