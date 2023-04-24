module "data_products" {
  source   = "./modules/dataproduct"
  for_each = local.data_product_definitions
  providers = {
    databricks                 = databricks.experimentation
    databricks.experimentation = databricks.experimentation
    databricks.automation      = databricks.automation
  }

  location                       = var.location
  data_product_name              = try("${each.value.id}-${each.value.environment}", "")
  tags                           = try(each.value.tags, {})
  network_enabled                = try(each.value.network.enabled, false)
  vnet_id                        = data.azurerm_virtual_network.virtual_network.id
  nsg_id                         = var.nsg_id
  route_table_id                 = var.route_table_id
  subnet_cidr_range              = try(each.value.network.subnet_cidr_range, "")
  private_dns_zone_id_key_vault  = var.private_dns_zone_id_key_vault
  identity_enabled               = try(each.value.identity.enabled, false)
  security_group_display_name    = try(each.value.identity.security_group_display_name, "")
  user_assigned_identity_enabled = try(each.value.identity.user_assigned_identity_enabled, false)
  service_principal_enabled      = try(each.value.identity.service_principal_enabled, false)
  containers_enabled = {
    raw       = try(each.value.storage_container.raw, false)
    enriched  = try(each.value.storage_container.enriched, false)
    curated   = try(each.value.storage_container.curated, false)
    workspace = try(each.value.storage_container.workspace, false)
  }
  datalake_raw_id            = module.datalake_raw.datalake_id
  datalake_enriched_id       = module.datalake_enriched.datalake_id
  datalake_curated_id        = module.datalake_curated.datalake_id
  datalake_workspace_id      = module.datalake_workspace.datalake_id
  databricks_enabled         = try(each.value.databricks.enabled, false)
  databricks_experimentation = try(each.value.databricks.experimentation, true)
  unity_metastore_id         = var.unity_metastore_id
  unity_catalog_configurations = {
    enabled      = try(each.value.databricks.unity_catalog.enabled, false)
    group_name   = try(each.value.databricks.unity_catalog.group_name, "")
    storage_root = try(each.value.databricks.unity_catalog.storage_root, "")
  }
}
