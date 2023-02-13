resource "azurerm_resource_deployment_script_azure_power_shell" "purview_admin_onboarding" {
  name                = "${azurerm_purview_account.purview.name}-admin-onb"
  location            = var.location
  resource_group_name = azurerm_resource_group.automation_rg.name
  tags                = var.tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }

  command_line       = "-PurviewId \"${azurerm_purview_account.purview.name}\" -PurviewRootCollectionAdmins ${var.purview_root_collection_admins}"
  cleanup_preference = "OnSuccess"
  container {
    container_group_name = "${azurerm_purview_account.purview.name}-admin-onb"
  }
  environment_variable {}
  force_update_tag       = timestamp()
  retention_interval     = "P1D"
  script_content         = file("./purviewAdminOnboarding/SetupPurview.ps1")
  supporting_script_uris = []
  timeout                = "PT30M"
  version                = "6.3"
}
