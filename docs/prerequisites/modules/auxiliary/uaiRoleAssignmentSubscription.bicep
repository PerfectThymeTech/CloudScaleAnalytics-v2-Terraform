// Licensed under the MIT license.

// The module contains a template to create a role assignment to a Subscription.
targetScope = 'subscription'

// Parameters
param userAssignedIdentityId string
@allowed([
  'Reader'
  'Contributor'
  'UserAccessAdministrator'
])
param role string

// Variables
var userAssignedIdentitySubscriptionId = length(split(userAssignedIdentityId, '/')) == 9 ? split(userAssignedIdentityId, '/')[2] : subscription().subscriptionId
var userAssignedIdentityResourceGroupName = length(split(userAssignedIdentityId, '/')) == 9 ? split(userAssignedIdentityId, '/')[4] : 'incorrectSegmentLength'
var userAssignedIdentityName = length(split(userAssignedIdentityId, '/')) == 9 ? last(split(userAssignedIdentityId, '/')) : 'incorrectSegmentLength'
var roles = {
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  UserAccessAdministrator: '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
}

// Resources
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' existing = {
  name: userAssignedIdentityName
  scope: resourceGroup(userAssignedIdentitySubscriptionId, userAssignedIdentityResourceGroupName)
}

resource functionRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(uniqueString(subscription().subscriptionId, userAssignedIdentity.id, roles[role]))
  scope: subscription()
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roles[role])
    principalId: userAssignedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Outputs
