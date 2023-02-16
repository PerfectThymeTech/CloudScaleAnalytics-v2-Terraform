// Licensed under the MIT license.

// This template is used as a module from the main.bicep template.
// The module contains a template to create network resources.
targetScope = 'resourceGroup'

// Parameters
param location string
param prefix string
param tags object

param vnetAddressPrefix string = '10.1.0.0/24'
param firewallPrivateIp string

// Variables
var routeTableName = '${prefix}-rt001'
var nsgName = '${prefix}-nsg001'
var vnetName = '${prefix}-vnet001'

// Resources
resource routeTable 'Microsoft.Network/routeTables@2020-11-01' = {
  name: routeTableName
  location: location
  tags: tags
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'to-firewall-default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallPrivateIp
          hasBgpOverride: false
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: nsgName
  location: location
  tags: tags
  properties: {
    securityRules: []
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: [
        firewallPrivateIp
      ]
    }
    enableDdosProtection: false
    subnets: []
  }
}

// Outputs
output vnetId string = vnet.id
