data "azurerm_virtual_network" "virtual_network" {
  name                = local.virtual_network.name
  resource_group_name = local.virtual_network.resource_group_name
}

resource "azurerm_subnet" "devops_subnet" {
  name                 = "DevOpsSubnet"
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 28 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 0))
  ]
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = null
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "devops_subnet_nsg" {
  network_security_group_id = var.nsg_id
  subnet_id                 = azurerm_subnet.devops_subnet.id
}

resource "azurerm_subnet_route_table_association" "devops_subnet_routetable" {
  route_table_id = var.route_table_id
  subnet_id      = azurerm_subnet.devops_subnet.id
}

resource "azurerm_subnet" "storage_subnet" {
  name                 = "StorageSubnet"
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 28 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 1))
  ]
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = null
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "storage_subnet_nsg" {
  network_security_group_id = var.nsg_id
  subnet_id                 = azurerm_subnet.storage_subnet.id
}

resource "azurerm_subnet_route_table_association" "storage_subnet_routetable" {
  route_table_id = var.route_table_id
  subnet_id      = azurerm_subnet.storage_subnet.id
}

resource "azurerm_subnet" "runtimes_subnet" {
  name                 = "RuntimesSubnet"
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 28 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 2))
  ]
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = null
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "runtimes_subnet_nsg" {
  network_security_group_id = var.nsg_id
  subnet_id                 = azurerm_subnet.runtimes_subnet.id
}

resource "azurerm_subnet_route_table_association" "runtimes_subnet_routetable" {
  route_table_id = var.route_table_id
  subnet_id      = azurerm_subnet.runtimes_subnet.id
}

resource "azurerm_subnet" "powerbi_subnet" {
  name                 = "PowerBiSubnet"
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 28 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 3))
  ]
  delegation {
    name = "PowerBIGatewaySubnetDelegation"
    service_delegation {
      name = "Microsoft.PowerPlatform/vnetaccesslinks"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = null
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "powerbi_subnet_nsg" {
  network_security_group_id = var.nsg_id
  subnet_id                 = azurerm_subnet.powerbi_subnet.id
}

resource "azurerm_subnet_route_table_association" "powerbi_subnet_routetable" {
  route_table_id = var.route_table_id
  subnet_id      = azurerm_subnet.powerbi_subnet.id
}

resource "azurerm_subnet" "shared_app_aut_subnet" {
  name                 = "SharedAppAutomationSubnet"
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 28 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 4))
  ]
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = null
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "shared_app_aut_subnet_nsg" {
  network_security_group_id = var.nsg_id
  subnet_id                 = azurerm_subnet.shared_app_aut_subnet.id
}

resource "azurerm_subnet_route_table_association" "shared_app_aut_subnet_routetable" {
  route_table_id = var.route_table_id
  subnet_id      = azurerm_subnet.shared_app_aut_subnet.id
}

resource "azurerm_subnet" "shared_app_exp_subnet" {
  name                 = "SharedAppExperimentationSubnet"
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 28 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 5))
  ]
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = null
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "shared_app_exp_subnet_nsg" {
  network_security_group_id = var.nsg_id
  subnet_id                 = azurerm_subnet.shared_app_exp_subnet.id
}

resource "azurerm_subnet_route_table_association" "shared_app_exp_subnet_routetable" {
  route_table_id = var.route_table_id
  subnet_id      = azurerm_subnet.shared_app_exp_subnet.id
}

resource "azurerm_subnet" "databricks_private_subnet_001" {
  name                 = "DatabricksPrivateSubnet001"
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 23 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 1))
  ]
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = null
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "databricks_private_subnet_001_nsg" {
  network_security_group_id = var.nsg_id
  subnet_id                 = azurerm_subnet.databricks_private_subnet_001.id
}

resource "azurerm_subnet_route_table_association" "databricks_private_subnet_001_routetable" {
  route_table_id = var.route_table_id
  subnet_id      = azurerm_subnet.databricks_private_subnet_001.id
}

resource "azurerm_subnet" "databricks_public_subnet_001" {
  name                 = "DatabricksPublicSubnet001"
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 23 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 2))
  ]
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = null
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "databricks_public_subnet_001_nsg" {
  network_security_group_id = var.nsg_id
  subnet_id                 = azurerm_subnet.databricks_public_subnet_001.id
}

resource "azurerm_subnet_route_table_association" "databricks_public_subnet_001_routetable" {
  route_table_id = var.route_table_id
  subnet_id      = azurerm_subnet.databricks_public_subnet_001.id
}

resource "azurerm_subnet" "databricks_private_subnet_002" {
  name                 = "DatabricksPrivateSubnet002"
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 23 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 3))
  ]
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = null
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "databricks_private_subnet_002_nsg" {
  network_security_group_id = var.nsg_id
  subnet_id                 = azurerm_subnet.databricks_private_subnet_002.id
}

resource "azurerm_subnet_route_table_association" "databricks_private_subnet_002_routetable" {
  route_table_id = var.route_table_id
  subnet_id      = azurerm_subnet.databricks_private_subnet_002.id
}

resource "azurerm_subnet" "databricks_public_subnet_002" {
  name                 = "DatabricksPublicSubnet002"
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 23 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 4))
  ]
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = null
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "databricks_public_subnet_002_nsg" {
  network_security_group_id = var.nsg_id
  subnet_id                 = azurerm_subnet.databricks_public_subnet_002.id
}

resource "azurerm_subnet_route_table_association" "databricks_public_subnet_002_routetable" {
  route_table_id = var.route_table_id
  subnet_id      = azurerm_subnet.databricks_public_subnet_002.id
}
