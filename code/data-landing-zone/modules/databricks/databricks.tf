resource "azurerm_databricks_workspace" "workspace" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.runtimes_rg
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
    private_subnet_network_security_group_association_id = ""
    public_subnet_name                                   = var.public_subnet_name
    public_subnet_network_security_group_association_id  = ""
    storage_account_name                                 = replace(var.workspace_name, "-", "")
    storage_account_sku_name                             = "Standard_ZRS"
  }
}
