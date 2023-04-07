resource "azurerm_databricks_workspace" "databricks" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  infrastructure_encryption_enabled     = true
  managed_resource_group_name           = "${var.workspace_name}-rg"
  network_security_group_rules_required = "NoAzureDatabricksRules"
  public_network_access_enabled         = false
  sku                                   = "premium"
  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = var.vnet_id
    private_subnet_name                                  = var.private_subnet_name
    private_subnet_network_security_group_association_id = var.private_subnet_network_security_group_association_id
    public_subnet_name                                   = var.public_subnet_name
    public_subnet_network_security_group_association_id  = var.public_subnet_network_security_group_association_id
    storage_account_name                                 = local.databricks.storage_account_name
    storage_account_sku_name                             = "Standard_ZRS"
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

resource "azurerm_private_endpoint" "databricks_private_endpoint_blob" {
  name                = "${azurerm_databricks_workspace.databricks.name}-blob-pe"
  location            = var.location
  resource_group_name = azurerm_databricks_workspace.databricks.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_databricks_workspace.databricks.name}-blob-nic"
  private_service_connection {
    name                           = "${azurerm_databricks_workspace.databricks.name}-blob-pe"
    is_manual_connection           = false
    private_connection_resource_id = "${azurerm_databricks_workspace.databricks.managed_resource_group_id}/providers/Microsoft.Storage/storageAccounts/${local.databricks.storage_account_name}"
    subresource_names              = ["blob"]
  }
  subnet_id = var.private_endpoints_subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_blob == "" ? [] : [1]
    content {
      name = "${azurerm_databricks_workspace.databricks.name}-blob-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_blob
      ]
    }
  }
}

resource "azurerm_private_endpoint" "databricks_private_endpoint_dfs" {
  name                = "${azurerm_databricks_workspace.databricks.name}-dfs-pe"
  location            = var.location
  resource_group_name = azurerm_databricks_workspace.databricks.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_databricks_workspace.databricks.name}-dfs-nic"
  private_service_connection {
    name                           = "${azurerm_databricks_workspace.databricks.name}-dfs-pe"
    is_manual_connection           = false
    private_connection_resource_id = "${azurerm_databricks_workspace.databricks.managed_resource_group_id}/providers/Microsoft.Storage/storageAccounts/${local.databricks.storage_account_name}"
    subresource_names              = ["dfs"]
  }
  subnet_id = var.private_endpoints_subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_dfs == "" ? [] : [1]
    content {
      name = "${azurerm_databricks_workspace.databricks.name}-dfs-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_dfs
      ]
    }
  }
}
