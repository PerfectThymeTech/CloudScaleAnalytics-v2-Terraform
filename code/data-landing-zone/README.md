<!-- BEGIN_TF_DOCS -->


## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (1.6.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (2.39.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (3.56.0)

- <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) (1.16.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (3.5.1)

- <a name="requirement_time"></a> [time](#requirement\_time) (0.9.1)

## Modules

The following Modules are called:

### <a name="module_data_products"></a> [data\_products](#module\_data\_products)

Source: ./modules/dataproduct

Version:

### <a name="module_databricks_automation"></a> [databricks\_automation](#module\_databricks\_automation)

Source: ./modules/databricks

Version:

### <a name="module_databricks_automation_configuration"></a> [databricks\_automation\_configuration](#module\_databricks\_automation\_configuration)

Source: ./modules/databricksconfiguration

Version:

### <a name="module_databricks_experimentation"></a> [databricks\_experimentation](#module\_databricks\_experimentation)

Source: ./modules/databricks

Version:

### <a name="module_databricks_experimentation_configuration"></a> [databricks\_experimentation\_configuration](#module\_databricks\_experimentation\_configuration)

Source: ./modules/databricksconfiguration

Version:

### <a name="module_datalake_curated"></a> [datalake\_curated](#module\_datalake\_curated)

Source: ./modules/datalake

Version:

### <a name="module_datalake_enriched"></a> [datalake\_enriched](#module\_datalake\_enriched)

Source: ./modules/datalake

Version:

### <a name="module_datalake_raw"></a> [datalake\_raw](#module\_datalake\_raw)

Source: ./modules/datalake

Version:

### <a name="module_datalake_workspace"></a> [datalake\_workspace](#module\_datalake\_workspace)

Source: ./modules/datalake

Version:

### <a name="module_shir_001"></a> [shir\_001](#module\_shir\_001)

Source: ./modules/selfhostedintegrationruntime

Version:

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username)

Description: Specifies the admin username of the VMs used for the Self-hosted Integration Runtimes

Type: `string`

### <a name="input_data_platform_subscription_ids"></a> [data\_platform\_subscription\_ids](#input\_data\_platform\_subscription\_ids)

Description: Specifies the list of subscription IDs of your data platform.

Type: `list(string)`

### <a name="input_databricks_admin_groupname"></a> [databricks\_admin\_groupname](#input\_databricks\_admin\_groupname)

Description: Specifies the databricks admin group name that should be granted access to the Databricks workspace artifacts

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location for all Azure resources.

Type: `string`

### <a name="input_nsg_id"></a> [nsg\_id](#input\_nsg\_id)

Description: Specifies the resource ID of the default network security group for the Data Landing Zone

Type: `string`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: Specifies the prefix for all resources created in this deployment.

Type: `string`

### <a name="input_private_dns_zone_id_blob"></a> [private\_dns\_zone\_id\_blob](#input\_private\_dns\_zone\_id\_blob)

Description: Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints.

Type: `string`

### <a name="input_private_dns_zone_id_data_factory"></a> [private\_dns\_zone\_id\_data\_factory](#input\_private\_dns\_zone\_id\_data\_factory)

Description: Specifies the resource ID of the private DNS zone for Azure Data Factory.

Type: `string`

### <a name="input_private_dns_zone_id_data_factory_portal"></a> [private\_dns\_zone\_id\_data\_factory\_portal](#input\_private\_dns\_zone\_id\_data\_factory\_portal)

Description: Specifies the resource ID of the private DNS zone for Azure Data Factory Portal.

Type: `string`

### <a name="input_private_dns_zone_id_databricks"></a> [private\_dns\_zone\_id\_databricks](#input\_private\_dns\_zone\_id\_databricks)

Description: Specifies the resource ID of the private DNS zone for Azure Databricks UI endpoints.

Type: `string`

### <a name="input_private_dns_zone_id_dfs"></a> [private\_dns\_zone\_id\_dfs](#input\_private\_dns\_zone\_id\_dfs)

Description: Specifies the resource ID of the private DNS zone for Azure Storage dfs endpoints.

Type: `string`

### <a name="input_private_dns_zone_id_key_vault"></a> [private\_dns\_zone\_id\_key\_vault](#input\_private\_dns\_zone\_id\_key\_vault)

Description: Specifies the resource ID of the private DNS zone for Azure Key Vault.

Type: `string`

### <a name="input_private_dns_zone_id_queue"></a> [private\_dns\_zone\_id\_queue](#input\_private\_dns\_zone\_id\_queue)

Description: Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints.

Type: `string`

### <a name="input_private_dns_zone_id_table"></a> [private\_dns\_zone\_id\_table](#input\_private\_dns\_zone\_id\_table)

Description: Specifies the resource ID of the private DNS zone for Azure Storage table endpoints.

Type: `string`

### <a name="input_purview_id"></a> [purview\_id](#input\_purview\_id)

Description: Specifies the resource ID of the default Purview Account for the Data Landing Zone

Type: `string`

### <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id)

Description: Specifies the resource ID of the default route table for the Data Landing Zone

Type: `string`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies the tags that you want to apply to all resources.

Type: `map(string)`

### <a name="input_vnet_id"></a> [vnet\_id](#input\_vnet\_id)

Description: Specifies the resource ID of the Vnet used for the Data Landing Zone

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_data_product_library_path"></a> [data\_product\_library\_path](#input\_data\_product\_library\_path)

Description: If specified, sets the path to a custom library folder for archetype artefacts.

Type: `string`

Default: `""`

### <a name="input_data_product_template_file_variables"></a> [data\_product\_template\_file\_variables](#input\_data\_product\_template\_file\_variables)

Description: If specified, provides the ability to define custom template variables used when reading in dtaa product template files from the library path.

Type: `any`

Default: `{}`

### <a name="input_environment"></a> [environment](#input\_environment)

Description: Specifies the environment of the deployment.

Type: `string`

Default: `"dev"`

### <a name="input_unity_metastore_id"></a> [unity\_metastore\_id](#input\_unity\_metastore\_id)

Description: Specifies the id of the Databricks Unity metastore.

Type: `string`

Default: `""`

### <a name="input_unity_metastore_name"></a> [unity\_metastore\_name](#input\_unity\_metastore\_name)

Description: Specifies the name of the Databricks Unity metastore.

Type: `string`

Default: `""`

## Outputs

No outputs.

<!-- markdownlint-enable -->


<!-- END_TF_DOCS -->