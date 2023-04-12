locals {
  names = {
    resource_group         = "${var.data_product_name}-rg"
    subnet                 = "DataProductSubnet-${var.data_product_name}"
    user_assigned_identity = "${var.data_product_name}-uai001"
    container_raw          = var.data_product_name
    container_enriched     = var.data_product_name
    container_curated      = var.data_product_name
    container_workspace    = var.data_product_name
    service_principal      = var.data_product_name
  }

  virtual_network = {
    resource_group_name = try(split("/", var.vnet_id)[4], "")
    name                = try(split("/", var.vnet_id)[8], "")
  }

  network_security_group = {
    resource_group_name = try(split("/", var.nsg_id)[4], "")
    name                = try(split("/", var.nsg_id)[8], "")
  }

  route_table = {
    resource_group_name = try(split("/", var.route_table_id)[4], "")
    name                = try(split("/", var.route_table_id)[8], "")
  }

  datalake_raw = {
    resource_group_name = try(split("/", var.datalake_raw_id)[4], "")
    name                = try(split("/", var.datalake_raw_id)[8], "")
  }

  datalake_enriched = {
    resource_group_name = try(split("/", var.datalake_enriched_id)[4], "")
    name                = try(split("/", var.datalake_enriched_id)[8], "")
  }

  datalake_curated = {
    resource_group_name = try(split("/", var.datalake_curated_id)[4], "")
    name                = try(split("/", var.datalake_curated_id)[8], "")
  }

  datalake_workspace = {
    resource_group_name = try(split("/", var.datalake_workspace_id)[4], "")
    name                = try(split("/", var.datalake_workspace_id)[8], "")
  }
}
