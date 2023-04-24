locals {
  names = {
    resource_group                = "${var.data_product_name}-rg"
    subnet                        = "DataProductSubnet-${var.data_product_name}"
    user_assigned_identity        = "${var.data_product_name}-uai001"
    key_vault                     = "${var.data_product_name}-vault001"
    container_raw                 = var.data_product_name
    container_enriched            = var.data_product_name
    container_curated             = var.data_product_name
    container_workspace           = var.data_product_name
    service_principal             = var.data_product_name
    databricks_access_connector   = "${var.data_product_name}-dbac001"
    databricks_cluster            = "${var.data_product_name}-cluster001"
    databricks_storage_credential = var.data_product_name
    databricks_external_location  = var.data_product_name
    databricks_catalog            = var.data_product_name
  }

  virtual_network = {
    resource_group_name = try(split("/", var.vnet_id)[4], "")
    name                = try(split("/", var.vnet_id)[8], "")
  }

  network_security_group = {
    resource_group_name = try(split("/", var.nsg_id)[4], "")
    name                = try(split("/", var.nsg_id)[8], "")
  }

  route_table = {
    resource_group_name = try(split("/", var.route_table_id)[4], "")
    name                = try(split("/", var.route_table_id)[8], "")
  }

  datalake_raw = {
    resource_group_name = try(split("/", var.datalake_raw_id)[4], "")
    name                = try(split("/", var.datalake_raw_id)[8], "")
  }

  datalake_enriched = {
    resource_group_name = try(split("/", var.datalake_enriched_id)[4], "")
    name                = try(split("/", var.datalake_enriched_id)[8], "")
  }

  datalake_curated = {
    resource_group_name = try(split("/", var.datalake_curated_id)[4], "")
    name                = try(split("/", var.datalake_curated_id)[8], "")
  }

  datalake_workspace = {
    resource_group_name = try(split("/", var.datalake_workspace_id)[4], "")
    name                = try(split("/", var.datalake_workspace_id)[8], "")
  }

  datalake_names = {
    raw       = data.azurerm_storage_account.datalake_raw.name
    enriched  = data.azurerm_storage_account.datalake_enriched.name
    curated   = data.azurerm_storage_account.datalake_curated.name
    workspace = data.azurerm_storage_account.datalake_workspace.name
  }
  container_names = {
    raw       = one(azapi_resource.container_raw[*].name)
    enriched  = one(azapi_resource.container_enriched[*].name)
    curated   = one(azapi_resource.container_curated[*].name)
    workspace = one(azapi_resource.container_workspace[*].name)
  }
  databricks_catalog_storage_root = "abfss://${lookup(local.container_names, var.unity_catalog_configurations.storage_root, "")}@${lookup(local.datalake_names, var.unity_catalog_configurations.storage_root, "")}.dfs.core.windows.net"
}
