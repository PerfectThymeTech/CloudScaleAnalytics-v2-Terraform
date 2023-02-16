// Licensed under the MIT license.

targetScope = 'subscription'

// General parameters
@description('Specifies the location for all resources.')
param location string
@allowed([
  'dev'
  'tst'
  'prd'
])
@description('Specifies the environment of the deployment.')
param environment string = 'dev'
@minLength(2)
@maxLength(10)
@description('Specifies the prefix for all resources created in this deployment.')
param prefix string
@description('Specifies the tags that you want to apply to all resources.')
param tags object = {}

// Variables
var name = toLower('${prefix}-${environment}')
var networkResourceGroupName = '${name}-network'
var globalDnsResourceGroupName = '${name}-global-dns'
var dataManagementZoneNetworkResourceGroupName = '${name}-dmgmt-network-rg'
var dataLandingZone01NetworkResourceGroupName = '${name}-dlz01-network-rg'

// Network resources
resource networkResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: networkResourceGroupName
  location: location
  tags: tags
  properties: {}
}

module networkServices 'modules/networkHub.bicep' = {
  name: 'networkServices'
  scope: networkResourceGroup
  params: {
    prefix: name
    location: location
    tags: tags
    vnetAddressPrefix: '10.0.0.0/20'
    azureFirewallSubnetAddressPrefix: '10.0.0.0/24'
    servicesSubnetAddressPrefix: '10.0.1.0/27'
    firewallTier: 'Standard'
    virtualNetworkManagerManagementGroupScopes: []
    virtualNetworkManagerSubscriptionScopes: [
      subscription().id
    ]
  }
}

module networkConfiguration 'modules/networkConfiguration.bicep' = {
  name: 'networkConfiguration'
  scope: networkResourceGroup
  params: {
    hubVirtualNetworkId: networkServices.outputs.vnetId
    virtualNetworkManagerId: networkServices.outputs.virtualNetworkManagerId
    spokeVirtualNetworkIds: [
      dataManagementZoneNetworkResources.outputs.vnetId
      dataLandingZone01NetworkResources.outputs.vnetId
    ]
  }
}

// Private DNS zones
resource globalDnsResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: globalDnsResourceGroupName
  location: location
  tags: tags
  properties: {}
}

module globalDnsZones 'modules/privatednszones.bicep' = {
  name: 'globalDnsZones'
  scope: globalDnsResourceGroup
  params: {
    tags: tags
    vnetId: networkServices.outputs.vnetId
  }
}

// Data Management Zone Virtual Network
resource dataManagementZoneNetworkResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: dataManagementZoneNetworkResourceGroupName
  location: location
  tags: tags
  properties: {}
}

module dataManagementZoneNetworkResources 'modules/networkSpoke.bicep' = {
  name: 'dataManagementZoneNetworkResources'
  scope: dataManagementZoneNetworkResourceGroup
  params: {
    location: location
    prefix: '${name}-dmgmt'
    tags: tags
    firewallPrivateIp: networkServices.outputs.firewallPrivateIp
    vnetAddressPrefix: '10.0.16.0/24'
  }
}

// Data Landing Zone Virtual Network
resource dataLandingZone01NetworkResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: dataLandingZone01NetworkResourceGroupName
  location: location
  tags: tags
  properties: {}
}

module dataLandingZone01NetworkResources 'modules/networkSpoke.bicep' = {
  name: 'dataLandingZone01NetworkResources'
  scope: dataLandingZone01NetworkResourceGroup
  params: {
    location: location
    prefix: '${name}-dlz01'
    tags: tags
    firewallPrivateIp: networkServices.outputs.firewallPrivateIp
    vnetAddressPrefix: '10.0.32.0/20'
  }
}

// Outputs
output hubVnetId string = networkServices.outputs.vnetId
output firewallPrivateIp string = networkServices.outputs.firewallPrivateIp
