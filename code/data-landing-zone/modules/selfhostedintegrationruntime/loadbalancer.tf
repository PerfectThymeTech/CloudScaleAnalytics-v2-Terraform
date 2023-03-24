resource "azurerm_lb" "lb" {
  name                = "${var.selfhostedintegrationruntime_name}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  frontend_ip_configuration {
    name                          = "frontendipconfiguration"
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    subnet_id                     = var.subnet_id
    zones                         = ["1", "2", "3"]
  }
  sku      = "Standard"
  sku_tier = "Regional"
}

resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  name            = "${var.selfhostedintegrationruntime_name}-backendaddresspool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_backend_address_pool_address" "lb_backend_address_pool_address" {
  name                                = "${var.selfhostedintegrationruntime_name}-backendaddresspool-address"
  backend_address_ip_configuration_id = azurerm_lb.lb.frontend_ip_configuration[0].id
  backend_address_pool_id             = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

resource "azurerm_lb_nat_pool" "lb_nat_pool" {
  name                = "${var.selfhostedintegrationruntime_name}-natpool"
  loadbalancer_id     = azurerm_lb.lb.id
  resource_group_name = azurerm_lb.lb.resource_group_name

  backend_port                   = 3389
  floating_ip_enabled            = false
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  frontend_port_start            = 50000
  frontend_port_end              = 50099
  idle_timeout_in_minutes        = 4
  protocol                       = "Tcp"
  tcp_reset_enabled              = true
}

# resource "azurerm_lb_nat_rule" "lb_nat_rule" {
#   name = "${var.selfhostedintegrationruntime_name}-natrule"
#   loadbalancer_id = azurerm_lb.lb.id
#   resource_group_name = azurerm_lb.lb.resource_group_name

#   backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
#   backend_port = 3389
#   enable_floating_ip = false
#   enable_tcp_reset = true
#   frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
#   frontend_port = 3389
#   idle_timeout_in_minutes = 4
#   protocol = "Tcp"
# }

# resource "azurerm_lb_outbound_rule" "lb_outbound_rule" {
#   name = "${var.selfhostedintegrationruntime_name}-outboundrule"
#   loadbalancer_id = azurerm_lb.lb.id

#   allocated_outbound_ports =
#   backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
#   enable_tcp_reset = true
#   frontend_ip_configuration {
#     name = azurerm_lb.lb.frontend_ip_configuration[0].name
#   }
#   idle_timeout_in_minutes = 4
#   protocol = "Tcp"
# }

resource "azurerm_lb_probe" "lb_probe" {
  name            = "${var.selfhostedintegrationruntime_name}-probe"
  loadbalancer_id = azurerm_lb.lb.id

  interval_in_seconds = 5
  number_of_probes    = 2
  port                = 80
  protocol            = "Http"
  request_path        = "/"
}

resource "azurerm_lb_rule" "lb_rule" {
  name            = "${var.selfhostedintegrationruntime_name}-rule"
  loadbalancer_id = azurerm_lb.lb.id

  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_address_pool.id]
  backend_port                   = 80
  disable_outbound_snat          = false
  enable_floating_ip             = false
  enable_tcp_reset               = true
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  frontend_port                  = 80
  idle_timeout_in_minutes        = 4
  load_distribution              = "Default"
  probe_id                       = azurerm_lb_probe.lb_probe.id
  protocol                       = "Tcp"
}
