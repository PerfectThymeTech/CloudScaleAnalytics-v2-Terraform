module "datalake_raw" {
  source = "./modules/datalake"

  location = var.location
  resource_group_name = azurerm_resource_group.storage_rg.name
  tags = var.tags
  datalake_name = replace("-", "${local.prefix}-st-raw")
  datalake_filesystem_names = [ "data" ]
  subnet_id = azurerm_subnet.storage_subnet.id
  private_dns_zone_id_blob = var.private_dns_zone_id_blob
  private_dns_zone_id_dfs = var.private_dns_zone_id_dfs
}

module "datalake_curated" {
  source = "./modules/datalake"

  location = var.location
  resource_group_name = azurerm_resource_group.storage_rg.name
  tags = var.tags
  datalake_name = replace("-", "${local.prefix}-st-cur")
  datalake_filesystem_names = [ "data" ]
  subnet_id = azurerm_subnet.storage_subnet.id
  private_dns_zone_id_blob = var.private_dns_zone_id_blob
  private_dns_zone_id_dfs = var.private_dns_zone_id_dfs
}

module "datalake_workspace" {
  source = "./modules/datalake"

  location = var.location
  resource_group_name = azurerm_resource_group.storage_rg.name
  tags = var.tags
  datalake_name = replace("-", "${local.prefix}-st-wsp")
  datalake_filesystem_names = [ "data" ]
  subnet_id = azurerm_subnet.storage_subnet.id
  private_dns_zone_id_blob = var.private_dns_zone_id_blob
  private_dns_zone_id_dfs = var.private_dns_zone_id_dfs
}
