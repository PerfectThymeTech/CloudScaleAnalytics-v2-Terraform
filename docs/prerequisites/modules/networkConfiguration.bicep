// Licensed under the MIT license.

// This template is used as a module from the main.bicep template.
// The module contains a template to create network resources.
targetScope = 'resourceGroup'

// Parameters
param hubVirtualNetworkId string
param spokeVirtualNetworkIds array = []
param virtualNetworkManagerId string

// Variables
#disable-next-line BCP321
var virtualNetworkManagerName = length(split(virtualNetworkManagerId, '/')) == 9 ? last(split(virtualNetworkManagerId, '/')) : 'incorrectSegmentLength'

// Resources
resource virtualNetworkManager 'Microsoft.Network/networkManagers@2022-07-01' existing = {
  #disable-next-line BCP321
  name: virtualNetworkManagerName
}

resource virtualNetworkManagerGroup 'Microsoft.Network/networkManagers/networkGroups@2022-07-01' = {
  parent: virtualNetworkManager
  name: 'HubAndSpokeNetworkGroup'
  properties: {
    description: 'Network group for hub and spoke network architecture.'
  }
}

resource virtualNetworkManagerGroupStaticMembers 'Microsoft.Network/networkManagers/networkGroups/staticMembers@2022-07-01' = [ for (item, index) in spokeVirtualNetworkIds: {
  parent: virtualNetworkManagerGroup
  name: 'HubAndSpokeNetworkGroupMembers${index}'
  properties: {
    resourceId: item
  }
}]

resource virtualNetworkManagerConnectivityConfiguration 'Microsoft.Network/networkManagers/connectivityConfigurations@2022-07-01' = {
  parent: virtualNetworkManager
  name: 'HubAndSpokeConnectivityConfiguration'
  properties: {
    appliesToGroups: [
      {
        groupConnectivity: 'DirectlyConnected'
        networkGroupId: virtualNetworkManagerGroup.id
        isGlobal: 'True'
        useHubGateway: 'False'
      }
    ]
    connectivityTopology: 'HubAndSpoke'
    deleteExistingPeering: 'False'
    description: 'Hub and Spoke connectivity configuration.'
    hubs: [
      {
        resourceType: 'Microsoft.Network/virtualNetworks'
        resourceId: hubVirtualNetworkId
      }
    ]
    isGlobal: 'True'
  }
}

// Outputs
