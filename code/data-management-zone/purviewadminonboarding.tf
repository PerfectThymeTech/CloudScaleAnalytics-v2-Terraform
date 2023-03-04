resource "azurerm_resource_deployment_script_azure_power_shell" "purview_admin_onboarding" {
  count               = length(var.purview_root_collection_admins) > 0 ? 1 : 0
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

  command_line       = "-PurviewId \"${azurerm_purview_account.purview.id}\" -PurviewRootCollectionAdmins ${join(",", [for admin in var.purview_root_collection_admins : format("%q", admin)])}"
  cleanup_preference = "OnSuccess"
  container {
    container_group_name = "${azurerm_purview_account.purview.name}-admin-onb"
  }
  force_update_tag       = timestamp()
  retention_interval     = "P1D"
  script_content         = file("./purviewAdminOnboarding/SetupPurview.ps1")
  supporting_script_uris = []
  timeout                = "PT30M"
  version                = "6.3"

  depends_on = [
    azurerm_role_assignment.user_assigned_identity_roleassignment_governance_rg
  ]
}
