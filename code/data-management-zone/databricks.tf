resource "azurerm_databricks_workspace" "databricks" {
  name                = "${local.prefix}-cnsmptn-dbw001"
  location            = var.location
  resource_group_name = azurerm_resource_group.consumption_rg.name
  tags                = var.tags

  infrastructure_encryption_enabled     = true
  managed_resource_group_name           = "${local.prefix}-cnsmptn-dbw001-rg"
  network_security_group_rules_required = "NoAzureDatabricksRules"
  public_network_access_enabled         = false
  sku                                   = "premium"
  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = data.azurerm_virtual_network.virtual_network.id
    private_subnet_name                                  = azurerm_subnet.databricks_private_subnet.name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.databricks_private_subnet_nsg.id
    public_subnet_name                                   = azurerm_subnet.databricks_public_subnet.name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.databricks_public_subnet_nsg.id
    storage_account_name                                 = replace("${local.prefix}-cnsmptn-dbw001", "-", "")
    storage_account_sku_name                             = "Standard_LRS"
  }
}

resource "azurerm_private_endpoint" "databricks_private_endpoint_ui" {
  name                = "${azurerm_databricks_workspace.databricks.name}-uiapi-pe"
  location            = var.location
  resource_group_name = azurerm_databricks_workspace.databricks.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_databricks_workspace.databricks.name}-uiapi-nic"
  private_service_connection {
    name                           = "${azurerm_databricks_workspace.databricks.name}-uiapi-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.databricks.id
    subresource_names              = ["databricks_ui_api"]
  }
  subnet_id = var.private_endpoints_subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_databricks == "" ? [] : [1]
    content {
      name = "${azurerm_databricks_workspace.databricks.name}-uiapi-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_databricks
      ]
    }
  }
}

resource "azurerm_private_endpoint" "databricks_private_endpoint_web" {
  name                = "${azurerm_databricks_workspace.databricks.name}-web-pe"
  location            = var.location
  resource_group_name = azurerm_databricks_workspace.databricks.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_databricks_workspace.databricks.name}-web-nic"
  private_service_connection {
    name                           = "${azurerm_databricks_workspace.databricks.name}-web-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.databricks.id
    subresource_names              = ["browser_authentication"]
  }
  subnet_id = var.private_endpoints_subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_databricks == "" ? [] : [1]
    content {
      name = "${azurerm_databricks_workspace.databricks.name}-web-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_databricks
      ]
    }
  }
}
