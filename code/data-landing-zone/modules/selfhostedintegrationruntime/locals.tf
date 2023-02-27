locals {
  data_factory = {
    resource_group_name = split("/", var.data_factory_id)[4]
    name                = split("/", var.data_factory_id)[8]
  }
  shared_data_factories = [
    for shared_data_factory_id in var.shared_data_factory_ids : {
      resource_group_name = split("/", shared_data_factory_id)[4]
      name                = split("/", shared_data_factory_id)[8]
    }
  ]
}
