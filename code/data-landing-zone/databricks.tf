module "databricks_automation" {
  source = "./modules/databricks"

  location                                             = var.location
  resource_group_name                                  = azurerm_resource_group.shared_app_aut_rg.name
  tags                                                 = var.tags
  workspace_name                                       = "${local.prefix}-aut-dbw001"
  vnet_id                                              = data.azurerm_virtual_network.virtual_network.id
  private_subnet_name                                  = azurerm_subnet.databricks_private_subnet_001.name
  private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.databricks_private_subnet_001_nsg.id
  public_subnet_name                                   = azurerm_subnet.databricks_public_subnet_001.name
  public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.databricks_public_subnet_001_nsg.id
  private_endpoints_subnet_id                          = azurerm_subnet.shared_services_subnet.id
  private_dns_zone_id_databricks                       = var.private_dns_zone_id_databricks
}

module "databricks_experimentation" {
  source = "./modules/databricks"
  providers = {
    databricks = databricks.databricks_automation
  }

  location                                             = var.location
  resource_group_name                                  = azurerm_resource_group.shared_app_exp_rg.name
  tags                                                 = var.tags
  workspace_name                                       = "${local.prefix}-exp-dbw001"
  vnet_id                                              = data.azurerm_virtual_network.virtual_network.id
  private_subnet_name                                  = azurerm_subnet.databricks_private_subnet_002.name
  private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.databricks_private_subnet_002_nsg.id
  public_subnet_name                                   = azurerm_subnet.databricks_public_subnet_002.name
  public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.databricks_public_subnet_002_nsg.id
  private_endpoints_subnet_id                          = azurerm_subnet.shared_services_subnet.id
  private_dns_zone_id_databricks                       = var.private_dns_zone_id_databricks
}
