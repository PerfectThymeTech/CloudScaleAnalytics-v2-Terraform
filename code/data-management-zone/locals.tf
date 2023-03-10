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
}
