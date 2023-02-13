resource "azurerm_key_vault" "key_vault" {
  name                = "${local.prefix}-kv001"
  location            = var.location
  resource_group_name = azurerm_resource_group.governance_rg.name
  tags                = var.tags

  access_policy                   = []
  enable_rbac_authorization       = true
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  network_acls {
    bypass                     = "None"
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  public_network_access_enabled = true
  purge_protection_enabled      = true
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  tenant_id                     = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_private_endpoint" "key_vault_private_endpoint" {
  name                = "${azurerm_key_vault.key_vault.name}-pe"
  location            = var.location
  resource_group_name = azurerm_key_vault.key_vault.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_key_vault.key_vault.name}-nic"
  private_service_connection {
    name                           = "${azurerm_key_vault.key_vault.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
  }
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_key_vault == "" ? [] : [1]
    content {
      name = "${azurerm_key_vault.key_vault.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_key_vault
      ]
    }
  }
}
