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
@description('Specifies the administrator username of the virtual machine.')
param administratorUsername string = 'VmMainUser'
@secure()
@description('Specifies the administrator password of the virtual machine.')
param administratorPassword string

// Variables
var name = toLower('${prefix}-${environment}')
var bastionResourceGroupName = '${name}-bastion-rg'
var cicdResourceGroupName = '${name}-cicd-rg'
var networkResourceGroupName = '${name}-network-rg'
var globalDnsResourceGroupName = '${name}-global-dns-rg'
var dataManagementZoneNetworkResourceGroupName = '${name}-dmgmt-network-rg'
var dataLandingZone01NetworkResourceGroupName = '${name}-dlz01-network-rg'

// CICD resources
resource cicdResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: cicdResourceGroupName
  location: location
  tags: tags
  properties: {}
}

module cicdServices 'modules/cicd.bicep' = {
  name: 'cicdServices'
  scope: cicdResourceGroup
  params: {
    prefix: name
    location: location
    tags: tags
    subnetId: networkServices.outputs.serviceSubnetId
    privateDnsZoneIdBlob: globalDnsZones.outputs.privateDnsZoneIdBlob
  }
}

// Bastion resources
resource bastionResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: bastionResourceGroupName
  location: location
  tags: tags
  properties: {}
}

module bastionServices 'modules/bastion.bicep' = {
  name: 'bastionServices'
  scope: bastionResourceGroup
  params: {
    prefix: name
    location: location
    tags: tags
    bastionSubnetId: networkServices.outputs.bastionSubnetId
    vmSubnetId: networkServices.outputs.serviceSubnetId
    administratorUsername: administratorUsername
    administratorPassword: administratorPassword
  }
}

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
