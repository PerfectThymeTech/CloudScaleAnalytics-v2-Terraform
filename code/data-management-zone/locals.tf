locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  eventhub_namespace = {
    min_throughput = 1
    max_throughput = 1
    eventhub_notification = {
      name              = "notification"
      message_retention = 3
      partition_count   = 1
    }
    eventhub_hook = {
      name              = "hook"
      message_retention = 3
      partition_count   = 1
    }
  }

  virtual_network = {
    resource_group_name = split("/", var.vnet_id)[4]
    name                = split("/", var.vnet_id)[8]
  }

  network_security_group = {
    resource_group_name = try(split("/", var.nsg_id)[4], "")
    name                = try(split("/", var.nsg_id)[8], "")
  }

  route_table = {
    resource_group_name = try(split("/", var.route_table_id)[4], "")
    name                = try(split("/", var.route_table_id)[8], "")
  }

  unity_container_name = "unity${var.location}"
}
