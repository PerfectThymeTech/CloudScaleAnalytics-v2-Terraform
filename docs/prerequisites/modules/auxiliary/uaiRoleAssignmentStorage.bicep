// Licensed under the MIT license.

// The module contains a template to create a role assignment of the Machine Learning MSI to a Storage file system.
targetScope = 'resourceGroup'

// Parameters
param storageAccountId string
param userAssignedIdentityId string
@allowed([
  'Contributor'
  'StorageBlobDataReader'
  'StorageBlobDataContributor'
  'StorageBlobDataOwner'
])
param role string

// Variables
var storageAccountName = length(split(storageAccountId, '/')) == 9 ? last(split(storageAccountId, '/')) : 'incorrectSegmentLength'
var userAssignedIdentitySubscriptionId = length(split(userAssignedIdentityId, '/')) == 9 ? split(userAssignedIdentityId, '/')[2] : subscription().subscriptionId
var userAssignedIdentityResourceGroupName = length(split(userAssignedIdentityId, '/')) == 9 ? split(userAssignedIdentityId, '/')[4] : resourceGroup().name
var userAssignedIdentityName = length(split(userAssignedIdentityId, '/')) == 9 ? last(split(userAssignedIdentityId, '/')) : 'incorrectSegmentLength'
var roles = {
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  StorageBlobDataReader: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  StorageBlobDataContributor: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  StorageBlobDataOwner: 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b'
}

// Resources
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' existing = {
  name: userAssignedIdentityName
  scope: resourceGroup(userAssignedIdentitySubscriptionId, userAssignedIdentityResourceGroupName)
}

resource synapseRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(uniqueString(storageAccount.id, userAssignedIdentity.id, roles[role]))
  scope: storageAccount
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roles[role])
    principalId: userAssignedIdentity.properties.principalId
  }
}

// Outputs
