module "databricks_automation" {
  source = "./modules/databricks"

  location                                             = var.location
  resource_group_name                                  = azurerm_resource_group.shared_app_aut_rg.name
  tags                                                 = var.tags
  workspace_name                                       = "${local.prefix}-aut-dbw001"
  key_vault_name                                       = "${local.prefix}-aut-kv001"
  vnet_id                                              = data.azurerm_virtual_network.virtual_network.id
  private_subnet_name                                  = azurerm_subnet.databricks_private_subnet_001.name
  private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.databricks_private_subnet_001_nsg.id
  public_subnet_name                                   = azurerm_subnet.databricks_public_subnet_001.name
  public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.databricks_public_subnet_001_nsg.id
  private_endpoints_subnet_id                          = azurerm_subnet.shared_app_aut_subnet.id
  private_dns_zone_id_databricks                       = var.private_dns_zone_id_databricks
  private_dns_zone_id_key_vault                        = var.private_dns_zone_id_key_vault
  private_dns_zone_id_blob                             = var.private_dns_zone_id_blob
  private_dns_zone_id_dfs                              = var.private_dns_zone_id_dfs
}

module "databricks_automation_configuration" {
  source = "./modules/databricksconfiguration"
  providers = {
    databricks = databricks.automation
  }

  key_vault_id              = module.databricks_automation.key_vault_id
  key_vault_uri             = module.databricks_automation.key_vault_uri
  client_id_secret_name     = ""
  client_secret_secret_name = ""
  databricks_workspace_id   = module.databricks_automation.workspace_id
  unity_metastore_name      = var.unity_metastore_name
  unity_metastore_id        = var.unity_metastore_id
}

module "databricks_experimentation" {
  source = "./modules/databricks"

  location                                             = var.location
  resource_group_name                                  = azurerm_resource_group.shared_app_exp_rg.name
  tags                                                 = var.tags
  workspace_name                                       = "${local.prefix}-exp-dbw001"
  key_vault_name                                       = "${local.prefix}-exp-kv001"
  vnet_id                                              = data.azurerm_virtual_network.virtual_network.id
  private_subnet_name                                  = azurerm_subnet.databricks_private_subnet_002.name
  private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.databricks_private_subnet_002_nsg.id
  public_subnet_name                                   = azurerm_subnet.databricks_public_subnet_002.name
  public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.databricks_public_subnet_002_nsg.id
  private_endpoints_subnet_id                          = azurerm_subnet.shared_app_exp_subnet.id
  private_dns_zone_id_databricks                       = var.private_dns_zone_id_databricks
  private_dns_zone_id_key_vault                        = var.private_dns_zone_id_key_vault
  private_dns_zone_id_blob                             = var.private_dns_zone_id_blob
  private_dns_zone_id_dfs                              = var.private_dns_zone_id_dfs
}
