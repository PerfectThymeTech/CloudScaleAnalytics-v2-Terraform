resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name                = var.selfhostedintegrationruntime_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAsssigned"
  }

  admin_password = var.admin_password
  admin_username = var.admin_username
  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade = true
    disable_automatic_rollback  = false
  }
  # boot_diagnostics {
  #   storage_account_uri = 
  # }
  computer_name_prefix                              = substr(var.selfhostedintegrationruntime_name, 0, 9)
  custom_data                                       = filebase64("${path.module}/installShirGateway/Install-ShirGateway.ps1")
  do_not_run_extensions_on_overprovisioned_machines = true
  enable_automatic_updates                          = true
  encryption_at_host_enabled                        = true
  extension {
    name                       = "${var.selfhostedintegrationruntime_name}-shir"
    auto_upgrade_minor_version = true
    protected_settings = {
      commandToExecute = "powershell.exe -ExecutionPolicy Unrestricted -NoProfile -NonInteractive -command \"cp c:/azuredata/customdata.bin c:/azuredata/installSHIRGateway.ps1; c:/azuredata/installSHIRGateway.ps1 -gatewayKey \"${azurerm_data_factory_integration_runtime_self_hosted.data_factory_shir.primary_authorization_key}\""
    }
  }
  extension_operations_enabled = true
  instances                    = 1
  license_type                 = "None"
  network_interface {
    name                          = "${var.selfhostedintegrationruntime_name}-nic"
    enable_accelerated_networking = false
    enable_ip_forwarding          = false
    primary                       = true
    ip_configuration {
      name                                   = "${var.selfhostedintegrationruntime_name}-ipconfig"
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backend_address_pool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lb_nat_pool.id]
      primary                                = true
      subnet_id                              = var.subnet_id
      version                                = "IPv4"
    }
  }
  os_disk {
    caching = "ReadWrite"
    diff_disk_settings {
      option    = "Local"
      placement = "CacheDisk"
    }
    storage_account_type      = "Premium_ZRS"
    write_accelerator_enabled = false
  }
  overprovision               = false
  platform_fault_domain_count = 1
  priority                    = "Regular"
  provision_vm_agent          = true
  # rolling_upgrade_policy {
  #   cross_zone_upgrades_enabled = true
  #   max_unhealthy_instance_percent = 0
  #   max_unhealthy_upgraded_instance_percent = 0
  #   prioritize_unhealthy_instances_enabled = true
  # }
  secure_boot_enabled = true
  sku                 = "Standard_D4ads_v5"
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  timezone     = "UTC"
  upgrade_mode = "Automatic"
  # user_data = 
  vtpm_enabled = true
  zone_balance = false
  zones        = ["1", "2", "3"]
}
