data "azuread_group" "security_group" {
  count            = var.identity_enabled && var.security_group_display_name != "" ? 1 : 0
  display_name     = var.security_group_display_name
  security_enabled = true
}

resource "azuread_group_member" "security_group_uai_member" {
  count            = var.user_assigned_identity_enabled && (data.azuread_group.security_group[*].object_id) != null ? 1 : 0
  group_object_id  = one(data.azuread_group.security_group[*].object_id)
  member_object_id = one(azurerm_user_assigned_identity.user_assigned_identity[*].principal_id)
}
