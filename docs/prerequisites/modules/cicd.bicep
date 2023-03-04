// Licensed under the MIT license.

// This template is used as a module from the main.bicep template.
// The module contains a template to create cicd resources.
targetScope = 'resourceGroup'

// Parameters
param location string
param prefix string
param tags object

param subnetId string
param privateDnsZoneIdBlob string

// Variables
var userAssignedIdentityName = '${prefix}-uai001'
var storageName = replace('${prefix}-stg001', '-', '')
var storageContainerNames = [
  'data-management-zone'
  'data-landing-zone'
]
var storagePrivateEndpointNameBlob = '${storageName}-blob-pe'

// Resources
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: userAssignedIdentityName
  location: location
  tags: tags
}


resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Standard_ZRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowedCopyScope: 'AAD'
    allowCrossTenantReplication: false
    allowSharedKeyAccess: true
    defaultToOAuthAuthentication: true
    dnsEndpointType: 'Standard'
    encryption: {
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: false
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
        queue: {
          enabled: true
          keyType: 'Service'
        }
        table: {
          enabled: true
          keyType: 'Service'
        }
      }
    }
    // immutableStorageWithVersioning:{
    //   enabled: false
    //   immutabilityPolicy: {
    //     state: 'Disabled'
    //     allowProtectedAppendWrites: true
    //     immutabilityPeriodSinceCreationInDays: 7
    //   }
    // }
    isHnsEnabled: false
    isLocalUserEnabled: false
    isNfsV3Enabled: false
    isSftpEnabled: false
    keyPolicy: {
      keyExpirationPeriodInDays: 7
    }
    largeFileSharesState: 'Disabled'
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'Metrics, AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '0.0.0.0/0'
        }
      ]
      virtualNetworkRules: []
    }
    publicNetworkAccess: 'Enabled'
    routingPreference: {
      routingChoice: 'MicrosoftRouting'
      publishInternetEndpoints: false
      publishMicrosoftEndpoints: false
    }
    supportsHttpsTrafficOnly: true
    // sasPolicy: {
    //   expirationAction: 'Log'
    //   sasExpirationPeriod: ''
    // }
  }
}

resource storageBlobServices 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  parent: storage
  name: 'default'
  properties: {
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    // automaticSnapshotPolicyEnabled: true  // Uncomment, if you want to enable addition features on the storage account
    // changeFeed: {
    //   enabled: true
    //   retentionInDays: 7
    // }
    // defaultServiceVersion: ''
    // deleteRetentionPolicy: {
    //   enabled: true
    //   days: 7
    // }
    // isVersioningEnabled: true
    // lastAccessTimeTrackingPolicy: {
    //   name: 'AccessTimeTracking'
    //   enable: true
    //   blobType: [
    //     'blockBlob'
    //   ]
    //   trackingGranularityInDays: 1
    // }
    // restorePolicy: {
    //   enabled: true
    //   days: 7
    // }
  }
}

resource storageContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = [for storageContainerName in storageContainerNames: {
  parent: storageBlobServices
  name: storageContainerName
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}]


resource storagePrivateEndpointBlob 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: storagePrivateEndpointNameBlob
  location: location
  tags: tags
  properties: {
    applicationSecurityGroups: []
    customDnsConfigs: []
    customNetworkInterfaceName: '${storagePrivateEndpointNameBlob}-nic'
    manualPrivateLinkServiceConnections: []
    privateLinkServiceConnections: [
      {
        name: storagePrivateEndpointNameBlob
        properties: {
          groupIds: [
            'blob'
          ]
          privateLinkServiceId: storage.id
          requestMessage: ''
        }
      }
    ]
    subnet: {
      id: subnetId
    }
  }
}

resource storagePrivateEndpointBlobARecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-07-01' = if (!empty(privateDnsZoneIdBlob)) {
  parent: storagePrivateEndpointBlob
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${storagePrivateEndpointBlob.name}-arecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdBlob
        }
      }
    ]
  }
}

// Role Assignment
module uaiRoleAssignmentStorage 'auxiliary/uaiRoleAssignmentStorage.bicep' = {
  name: 'uaiRoleAssignmentStorage'
  scope: resourceGroup()
  params: {
    userAssignedIdentityId: userAssignedIdentity.id
    storageAccountId: storage.id
    role: 'StorageBlobDataContributor'
  }
}

module uaiRoleAssignmentSubscriptionContributor 'auxiliary/uaiRoleAssignmentSubscription.bicep' = {
  name: 'uaiRoleAssignmentSubscriptionContributor'
  scope: subscription()
  params: {
    userAssignedIdentityId: userAssignedIdentity.id
    role: 'Contributor'
  }
}

module uaiRoleAssignmentSubscriptionUserAccessAdmin 'auxiliary/uaiRoleAssignmentSubscription.bicep' = {
  name: 'uaiRoleAssignmentSubscriptionUserAccessAdmin'
  scope: subscription()
  params: {
    userAssignedIdentityId: userAssignedIdentity.id
    role: 'UserAccessAdministrator'
  }
}

// Outputs
