// Licensed under the MIT license.

// This template is used as a module from the main.bicep template.
// The module contains a template to create network resources.
targetScope = 'resourceGroup'

// Parameters
param location string
param prefix string
param tags object

param vnetAddressPrefix string = '10.0.0.0/20'
param azureFirewallSubnetAddressPrefix string = '10.0.0.0/24'
param servicesSubnetAddressPrefix string = '10.0.1.0/24'
@allowed([
  'Standard'
  'Premium'
])
param firewallTier string = 'Standard'
param virtualNetworkManagerManagementGroupScopes array = []
param virtualNetworkManagerSubscriptionScopes array = []

// Variables
var virtualNetworkManagerName = '${prefix}-vnm001'
var routeTableName = '${prefix}-rt001'
var nsgName = '${prefix}-nsg001'
var vnetName = '${prefix}-vnet001'
var publicIpPrefixName = '${prefix}-ippre001'
var publicIpName = '${prefix}-pip001'
var firewallPolicyName = '${prefix}-afwp001'
var firewallName = '${prefix}-afw001'
var azureFirewallSubnetName = 'AzureFirewallSubnet'
var servicesSubnetName = 'ServicesSubnet'
var firewallPremiumRegions = [
  'australiacentral'
  'australiacentral2'
  'australiaeast'
  'australiasoutheast'
  'brazilsouth'
  'brazilsoutheast'
  'canadacentral'
  'canadaeast'
  'centralindia'
  'centralus'
  'centraluseuap'
  'chinanorth2'
  'chinaeast2'
  'eastasia'
  'eastus'
  'eastus2'
  'francecentral'
  'francesouth'
  'germanywestcentral'
  'japaneast'
  'japanwest'
  'koreacentral'
  'koreasouth'
  'northcentralus'
  'northeurope'
  'norwayeast'
  'southafricanorth'
  'southcentralus'
  'southindia'
  'southeastasia'
  'swedencentral'
  'switzerlandnorth'
  'uaecentral'
  'uaenorth'
  'uksouth'
  'ukwest'
  'usgovarizona'
  'usgovtexas'
  'usgovvirginia'
  'westcentralus'
  'westeurope'
  'westindia'
  'westus'
  'westus2'
  'westus3'
]
var availabilityZoneRegions = [
  'australiaeast'
  'brazilsouth'
  'canadacentral'
  'centralus'
  'centralindia'
  'eastasia'
  'eastus'
  'eastus2'
  'francecentral'
  'germanywestcentral'
  'japaneast'
  'koreacentral'
  'northeurope'
  'norwayeast'
  'uksouth'
  'southeastasia'
  'southcentralus'
  'swedencentral'
  'usgovvirginia'
  'westeurope'
  'westus2'
  'westus3'
]

// Firewall Policy Variables
var firewallPolicyPremiumProperties = {
  intrusionDetection: {
    mode: 'Deny'
    configuration: {
      bypassTrafficSettings: []
      signatureOverrides: []
    }
  }
  threatIntelMode: 'Deny'
  threatIntelWhitelist: {
    fqdns: []
    ipAddresses: []
  }
  sku: {
    tier: 'Premium'
  }
  dnsSettings: {
    enableProxy: true
    servers: []
  }
}
var firewallPolicyStandardProperties = {
  threatIntelMode: 'Deny'
  threatIntelWhitelist: {
    fqdns: []
    ipAddresses: []
  }
  sku: {
    tier: 'Standard'
  }
  dnsSettings: {
    enableProxy: true
    servers: []
  }
}

// Resources
resource routeTable 'Microsoft.Network/routeTables@2020-11-01' = {
  name: routeTableName
  location: location
  tags: tags
  properties: {
    disableBgpRoutePropagation: false
    routes: []
  }
}

resource routeTableDefaultRoute 'Microsoft.Network/routeTables/routes@2020-11-01' = {
  name: 'to-firewall-default'
  parent: routeTable
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: firewall.properties.ipConfigurations[0].properties.privateIPAddress
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
      dnsServers: []
    }
    enableDdosProtection: false
    subnets: [
      {
        name: azureFirewallSubnetName
        properties: {
          addressPrefix: azureFirewallSubnetAddressPrefix
          addressPrefixes: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpointPolicies: []
          serviceEndpoints: []
        }
      }
      {
        name: servicesSubnetName
        properties: {
          addressPrefix: servicesSubnetAddressPrefix
          addressPrefixes: []
          networkSecurityGroup: {
            id: nsg.id
          }
          routeTable: {
            id: routeTable.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
          serviceEndpointPolicies: []
          serviceEndpoints: []
        }
      }
    ]
  }
}

resource publicIpPrefixes 'Microsoft.Network/publicIPPrefixes@2020-11-01' = {
  name: publicIpPrefixName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    prefixLength: 30
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIpName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: publicIpName
    }
    publicIPPrefix: {
      id: publicIpPrefixes.id
    }
  }
}

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-05-01' = {
  name: firewallPolicyName
  location: location
  tags: tags
  properties: firewallTier == 'Premium' && contains(firewallPremiumRegions, location) ? firewallPolicyPremiumProperties : firewallPolicyStandardProperties
}

module firewallPolicyRules 'firewallPolicyRules.bicep' = {
  name: '${prefix}-firewallpolicy-rules'
  scope: resourceGroup()
  params: {
    firewallPolicyName: firewallPolicy.name
  }
}

resource firewall 'Microsoft.Network/azureFirewalls@2020-11-01' = {
  name: firewallName
  dependsOn: [
    firewallPolicyRules
  ]
  location: location
  tags: tags
  zones: contains(availabilityZoneRegions, location) ? [
    '1'
    '2'
    '3'
  ] : []
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: contains(firewallPremiumRegions, location) ? firewallTier : 'Standard'
    }
    ipConfigurations: [
      {
        name: 'ipConfiguration001'
        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
    firewallPolicy: {
      id: firewallPolicy.id
    }
  }
}

resource virtualNetworkManager 'Microsoft.Network/networkManagers@2022-07-01' = {
  name: virtualNetworkManagerName
  location: location
  tags: tags
  properties: {
    // description: 'Network Manager for Network Architecture'
    networkManagerScopeAccesses: [
      'Connectivity'
      'SecurityAdmin'
    ]
    networkManagerScopes: {
      managementGroups: virtualNetworkManagerManagementGroupScopes
      subscriptions: virtualNetworkManagerSubscriptionScopes
    }
  }
}

// Outputs
output vnetId string = vnet.id
output serviceSubnetId string = vnet.properties.subnets[1].id
output firewallPrivateIp string = firewall.properties.ipConfigurations[0].properties.privateIPAddress
output virtualNetworkManagerId string = virtualNetworkManager.id
