// Licensed under the MIT license.

// This template is used as a module from the main.bicep template. 
// The module contains a template to deploy a bastion host.
targetScope = 'resourceGroup'

// Parameters
param location string
param prefix string
param tags object

param administratorUsername string = 'VmMainUser'
@secure()
param administratorPassword string
param bastionSubnetId string
param vmSubnetId string

// Variables
var bastionName = '${prefix}-bastion001'
var publicIpName = '${bastionName}-pip'
var virtualMachineName = '${prefix}-vm001'
var nicName = '${virtualMachineName}-nic'
var diskName = '${virtualMachineName}-disk'

var imageReferenceWindowsServer2022 = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2022-datacenter'
  version: 'latest'
}

// Resources
resource publicip 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
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
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2021-02-01' = {
  name: bastionName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    dnsName: bastionName
    ipConfigurations: [
      {
        name: 'ipConfiguration'
        properties: {
          subnet: {
            id: bastionSubnetId
          }
          publicIPAddress: {
            id: publicip.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName
  location: location
  tags: tags
  properties: {
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    ipConfigurations: [
      {
        name: 'ipConfig'
        properties: {
          primary: true
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vmSubnetId
          }
        }
      }
    ]
    nicType: 'Standard'
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-04-01' = {
  name: virtualMachineName
  location: location
  tags: tags
  // identity: {
  //   type: 'SystemAssigned'
  // }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS2_v2'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    osProfile: {
      adminUsername: administratorUsername
      adminPassword: administratorPassword
      computerName: take(virtualMachineName, 15)
      allowExtensionOperations: true
      windowsConfiguration: {
        enableAutomaticUpdates: true
      }
    }
    priority: 'Regular'
    storageProfile: {
      imageReference: imageReferenceWindowsServer2022
      osDisk: {
        name: diskName
        caching: 'ReadWrite'
        createOption: 'FromImage'
        osType: 'Windows'
        writeAcceleratorEnabled: false
      }
    }
  }
}

// Outputs
