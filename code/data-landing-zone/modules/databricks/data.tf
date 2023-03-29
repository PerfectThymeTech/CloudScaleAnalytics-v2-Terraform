data "azurerm_client_config" "current" {
}

data "azuread_service_principal" "databricks" {
  application_id = local.databricks.enterprise_application_id
}
