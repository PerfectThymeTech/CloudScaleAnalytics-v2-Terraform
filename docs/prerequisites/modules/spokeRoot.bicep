targetScope = 'subscription'

// Parameters
param location string
param prefix string
param tags object

param firewallPrivateIp string
param vnetAddressPrefix string

// Variables
var networkResourceGroupName = '${prefix}-network-rg' 

// Resources
resource networkResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: networkResourceGroupName
  location: location
  tags: tags
  properties: {}
}

module networkResources 'networkSpoke.bicep' = {
  name: 'networkResources'
  scope: networkResourceGroup
  params: {
    location: location
    prefix: prefix
    tags: tags
    firewallPrivateIp: firewallPrivateIp
    vnetAddressPrefix: vnetAddressPrefix
  }
}

// Outputs
output vnetId string = networkResources.outputs.vnetId
