<!-- BEGIN_TF_DOCS -->


## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.12 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.56.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | 1.16.0 |

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_company_name"></a> [company\_name](#input\_company\_name) | Specifies the name of the company. | `string` | n/a | yes |
| <a name="input_data_platform_subscription_ids"></a> [data\_platform\_subscription\_ids](#input\_data\_platform\_subscription\_ids) | Specifies the list of subscription IDs of your data platform. | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Specifies the location for all Azure resources. | `string` | n/a | yes |
| <a name="input_nsg_id"></a> [nsg\_id](#input\_nsg\_id) | Specifies the resource ID of the default network security group for the Data Management Zone | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Specifies the prefix for all resources created in this deployment. | `string` | n/a | yes |
| <a name="input_private_dns_zone_id_blob"></a> [private\_dns\_zone\_id\_blob](#input\_private\_dns\_zone\_id\_blob) | Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints. | `string` | n/a | yes |
| <a name="input_private_dns_zone_id_container_registry"></a> [private\_dns\_zone\_id\_container\_registry](#input\_private\_dns\_zone\_id\_container\_registry) | Specifies the resource ID of the private DNS zone for Azure Container Registry. | `string` | n/a | yes |
| <a name="input_private_dns_zone_id_databricks"></a> [private\_dns\_zone\_id\_databricks](#input\_private\_dns\_zone\_id\_databricks) | Specifies the resource ID of the private DNS zone for Azure Databricks UI endpoints. | `string` | n/a | yes |
| <a name="input_private_dns_zone_id_dfs"></a> [private\_dns\_zone\_id\_dfs](#input\_private\_dns\_zone\_id\_dfs) | Specifies the resource ID of the private DNS zone for Azure Storage dfs endpoints. | `string` | n/a | yes |
| <a name="input_private_dns_zone_id_key_vault"></a> [private\_dns\_zone\_id\_key\_vault](#input\_private\_dns\_zone\_id\_key\_vault) | Specifies the resource ID of the private DNS zone for Azure Key Vault. | `string` | n/a | yes |
| <a name="input_private_dns_zone_id_namespace"></a> [private\_dns\_zone\_id\_namespace](#input\_private\_dns\_zone\_id\_namespace) | Specifies the resource ID of the private DNS zone for the EventHub namespace. | `string` | n/a | yes |
| <a name="input_private_dns_zone_id_purview_account"></a> [private\_dns\_zone\_id\_purview\_account](#input\_private\_dns\_zone\_id\_purview\_account) | Specifies the resource ID of the private DNS zone for the Purview account. | `string` | n/a | yes |
| <a name="input_private_dns_zone_id_purview_portal"></a> [private\_dns\_zone\_id\_purview\_portal](#input\_private\_dns\_zone\_id\_purview\_portal) | Specifies the resource ID of the private DNS zone for the Purview portal. | `string` | n/a | yes |
| <a name="input_private_dns_zone_id_queue"></a> [private\_dns\_zone\_id\_queue](#input\_private\_dns\_zone\_id\_queue) | Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints. | `string` | n/a | yes |
| <a name="input_private_dns_zone_id_synapse_portal"></a> [private\_dns\_zone\_id\_synapse\_portal](#input\_private\_dns\_zone\_id\_synapse\_portal) | Specifies the resource ID of the private DNS zone for Synapse PL Hub. | `string` | n/a | yes |
| <a name="input_purview_root_collection_admins"></a> [purview\_root\_collection\_admins](#input\_purview\_root\_collection\_admins) | Specifies the list of user object IDs that are assigned as collection admin to the root collection in Purview. | `list(string)` | n/a | yes |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | Specifies the resource ID of the default route table for the Data Management Zone | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Specifies the tags that you want to apply to all resources. | `map(string)` | n/a | yes |
| <a name="input_vnet_id"></a> [vnet\_id](#input\_vnet\_id) | Specifies the resource ID of the Vnet used for the Data Management Zone | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Specifies the environment of the deployment. | `string` | `"dev"` | no |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.databricks_private_subnet](https://registry.terraform.io/providers/azure/azapi/1.6.0/docs/resources/resource) | resource |
| [azapi_resource.databricks_public_subnet](https://registry.terraform.io/providers/azure/azapi/1.6.0/docs/resources/resource) | resource |
| [azapi_resource.datalake_container_unity](https://registry.terraform.io/providers/azure/azapi/1.6.0/docs/resources/resource) | resource |
| [azapi_resource.private_endpoint_subnet](https://registry.terraform.io/providers/azure/azapi/1.6.0/docs/resources/resource) | resource |
| [azurerm_container_registry.container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/container_registry) | resource |
| [azurerm_databricks_access_connector.databricks_access_connector](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/databricks_access_connector) | resource |
| [azurerm_databricks_workspace.databricks](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/databricks_workspace) | resource |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/key_vault) | resource |
| [azurerm_private_endpoint.container_registry_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.databricks_private_endpoint_ui](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.databricks_private_endpoint_web](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.datalake_private_endpoint_blob](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.datalake_private_endpoint_dfs](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.key_vault_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.purview_private_endpoint_account](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.purview_private_endpoint_blob](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.purview_private_endpoint_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.purview_private_endpoint_portal](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.purview_private_endpoint_queue](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.synapse_pl_hub_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/private_endpoint) | resource |
| [azurerm_purview_account.purview](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/purview_account) | resource |
| [azurerm_resource_deployment_script_azure_power_shell.purview_admin_onboarding](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/resource_deployment_script_azure_power_shell) | resource |
| [azurerm_resource_group.automation_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.consumption_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.container_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.governance_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.unity_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.databricks_access_connector_roleassignment_datalake](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.purview_roleassignment_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.user_assigned_identity_roleassignment_governance_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.datalake](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/storage_account) | resource |
| [azurerm_storage_management_policy.datalake_management_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/storage_management_policy) | resource |
| [azurerm_synapse_private_link_hub.synapse_pl_hub](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/synapse_private_link_hub) | resource |
| [azurerm_user_assigned_identity.user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/user_assigned_identity) | resource |
| [databricks_metastore.metastore](https://registry.terraform.io/providers/databricks/databricks/1.16.0/docs/resources/metastore) | resource |
| [databricks_metastore_assignment.metastore_assignment](https://registry.terraform.io/providers/databricks/databricks/1.16.0/docs/resources/metastore_assignment) | resource |
| [databricks_metastore_data_access.metastore_data_access](https://registry.terraform.io/providers/databricks/databricks/1.16.0/docs/resources/metastore_data_access) | resource |
| [azapi_resource.purview](https://registry.terraform.io/providers/azure/azapi/1.6.0/docs/data-sources/resource) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/data-sources/client_config) | data source |
| [azurerm_network_security_group.network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/data-sources/network_security_group) | data source |
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/data-sources/route_table) | data source |
| [azurerm_virtual_network.virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/data-sources/virtual_network) | data source |

## Outputs

No outputs.

<!-- markdownlint-enable -->


<!-- END_TF_DOCS -->