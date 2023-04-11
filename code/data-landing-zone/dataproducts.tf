module "data_products" {
  source   = "./modules/dataproduct"
  for_each = {
    for item in local.data_product_definitions_per_env : "dp-${item.id}-${item.env}" => item.properties
  }

  location          = var.location
  data_product_name = each.key
  tags              = each.value.tags
  network_enabled   = each.value.network.enabled
  vnet_id           = data.azurerm_virtual_network.virtual_network.id
  nsg_id            = var.nsg_id
  route_table_id    = var.route_table_id
  subnet_cidr_range = each.value.subnet_cidr_range
  containers_enabled = {
    raw       = each.value.storage_container.raw
    enriched  = each.value.storage_container.enriched
    curated   = each.value.storage_container.curated
    workspace = each.value.storage_container.workspace
  }
  datalake_raw_id                = module.datalake_raw.datalake_id
  datalake_enriched_id           = module.datalake_enriched.datalake_id
  datalake_curated_id            = module.datalake_curated.datalake_id
  datalake_workspace_id          = module.datalake_workspace.datalake_id
  user_assigned_identity_enabled = each.value.settings.user_assigned_identity_enabled
  service_principal_enabled      = each.value.settings.service_principal_enabled
}
