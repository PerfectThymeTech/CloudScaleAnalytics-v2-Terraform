locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  virtual_network = {
    resource_group_name = split("/", var.vnet_id)[4]
    name                = split("/", var.vnet_id)[8]
  }
}
