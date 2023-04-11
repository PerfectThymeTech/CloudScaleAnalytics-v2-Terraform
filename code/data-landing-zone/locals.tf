locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  virtual_network = {
    resource_group_name = split("/", var.vnet_id)[4]
    name                = split("/", var.vnet_id)[8]
  }
}

locals {
  # Load file paths
  data_product_filepaths_json = tolist(fileset(local.data_product_library_path, "**/*.{json,json.tftpl}"))
  data_product_filepaths_yaml = tolist(fileset(local.data_product_library_path, "**/*.{yml,yml.tftpl,yaml,yaml.tftpl}"))

  # Load file content
  data_product_definitions_json = {
    for filepath in local.data_product_filepaths_json :
    filepath => jsondecode(templatefile("${local.data_product_library_path}/${filepath}", {}))
  }
  data_product_definitions_yaml = {
    for filepath in local.data_product_filepaths_yaml :
    filepath => yamldecode(templatefile("${local.data_product_library_path}/${filepath}", {}))
  }

  # Merge data
  data_product_definitions = merge(
    local.data_product_definitions_json,
    local.data_product_definitions_yaml
  )

  # Create item per environment
  data_product_definitions_per_env = flatten([
    for definition_key, definition_value in local.data_product_definitions : {
      for env in definition_value.environments :
      "dp-${definition_value.id}-${env}" => definition_value
    }
  ])
}
