module "databricks_consumption" {
  source = "./modules/databricks"

  location = var.location
  resource_group_name = azurerm_resource_group.consumption_rg.name
  tags = var.tags
  workspace_name = "${local.prefix}-cnsmptn-dbw001"
  vnet_id = data.azurerm_virtual_network.virtual_network.id
  private_subnet_name                                  = azurerm_subnet.databricks_private_subnet.name
  private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.databricks_private_subnet_nsg.id
  public_subnet_name                                   = azurerm_subnet.databricks_public_subnet.name
  public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.databricks_public_subnet_nsg.id
  private_endpoints_subnet_id                          = azurerm_subnet.private_endpoint_subnet.id
  private_dns_zone_id_databricks                       = var.private_dns_zone_id_databricks
}
