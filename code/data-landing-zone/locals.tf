locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  virtual_network = {
    resource_group_name = split("/", var.vnet_id)[4]
    name                = split("/", var.vnet_id)[8]
  }
}

locals {
  data_product_library_path = "${path.root}/dataproducts"
  # Load file paths
  data_product_filepaths_json = tolist(fileset(local.data_product_library_path, "**/*.{json,json.tftpl}"))
  data_product_filepaths_yaml = tolist(fileset(local.data_product_library_path, "**/*.{yml,yml.tftpl,yaml,yaml.tftpl}"))

  # Load file content
  data_product_definitions_json = {
    for filepath in local.data_product_filepaths_json :
    filepath => jsondecode(templatefile("${local.data_product_library_path}/${filepath}", var.data_product_template_file_variables))
  }
  data_product_definitions_yaml = {
    for filepath in local.data_product_filepaths_yaml :
    filepath => yamldecode(templatefile("${local.data_product_library_path}/${filepath}", var.data_product_template_file_variables))
  }

  # Merge data
  data_product_definitions = merge(
    local.data_product_definitions_json,
    local.data_product_definitions_yaml
  )
}
