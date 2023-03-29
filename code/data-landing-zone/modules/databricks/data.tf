data "azurerm_client_config" "current" {
}

data "azuread_application" "databricks" {
  application_id = local.databricks.enterprise_application_id
}
