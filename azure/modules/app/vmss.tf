locals {
  image_id = data.azurerm_shared_image_version.app_image.id
  default_image = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  devops_public_key = file("${path.module}/files/ssh-devops.pub")
  user_data         = replace(file("${path.module}/files/cloud-init.txt"), "__HOSTNAME_PREFIX__", var.vmss.hostname_prefix)

  notify_emails = var.notify_emails
}

# For Migrate，因為直接 VMSS per machine IP SKU 不符合預期
resource "azurerm_public_ip_prefix" "default" {
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location

  name          = lower("${var.vmss.name}-ip-prefix")
  prefix_length = 28

  sku = "Standard"
  tags = {
    CreatedBy = "Terraform"
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "default" {
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location

  name                 = var.vmss.name
  computer_name_prefix = var.vmss.name

  // vm_sku: https://docs.microsoft.com/zh-tw/azure/virtual-machines/fsv2-series
  sku       = "Standard_D2ls_v5"
  instances = var.vmss.instance_count

  admin_username = "devops"
  admin_ssh_key {
    username   = "devops"
    public_key = local.devops_public_key
  }

  upgrade_mode = "Manual"

  source_image_id = local.image_id
  dynamic "source_image_reference" {
    for_each = local.image_id != null ? [] : [1]
    content {
      publisher = local.default_image.publisher
      offer     = local.default_image.offer
      sku       = local.default_image.sku
      version   = local.default_image.version
    }
  }

  user_data = base64encode(local.user_data)

  overprovision = false

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
    disk_size_gb         = "64"
  }

  network_interface {
    name                      = lower("${var.vmss.name}-nic")
    primary                   = true
    network_security_group_id = var.security_group_id
    dns_servers               = []

    ip_configuration {
      name      = lower("${var.vmss.name}-ipconfig")
      primary   = true
      subnet_id = var.subnet_id
      version   = "IPv4"

      public_ip_address {
        name                    = lower("${var.vmss.name}-ip")
        idle_timeout_in_minutes = 10
        ## 首次設定需使用
        public_ip_prefix_id = azurerm_public_ip_prefix.default.id
      }

      load_balancer_backend_address_pool_ids = [
        ## 正式上線前，暫不使用 Load Balancer
        azurerm_lb_backend_address_pool.old_backend.id
      ]
      application_gateway_backend_address_pool_ids = []
      application_security_group_ids               = []
      load_balancer_inbound_nat_rules_ids          = []
    }
  }

  ## 正式上線前，暫不使用 Load Balancer
  health_probe_id = azurerm_lb_probe.tcp_53_probe.id
  automatic_instance_repair {
    enabled      = false
    grace_period = "PT10M"
  }

  depends_on = [
    azurerm_lb_rule.udp_53_rule
  ]

  tags = {
    CreatedBy = "Terraform"
  }
  lifecycle {
    ignore_changes = [
      instances
    ]
  }
}

// ISO_8601 Refs: https://en.wikipedia.org/wiki/ISO_8601#Durations
resource "azurerm_monitor_autoscale_setting" "default" {
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location

  name = "${var.vmss.name}-autoscale-setting"

  target_resource_id = azurerm_linux_virtual_machine_scale_set.default.id

  profile {
    name = "default-profile"

    capacity {
      default = var.vmss.instance_count
      minimum = var.vmss.capacity.min
      maximum = var.vmss.capacity.max
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.default.id

        time_grain       = "PT1M" // Period Time 1 min
        statistic        = "Average"
        time_window      = "PT2M" // Period Time 2 min
        time_aggregation = "Average"
        operator         = "GreaterThan"
        threshold        = 35
        metric_namespace = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M" // Period Time 5 min
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.default.id

        time_grain       = "PT1M" // 粒度: Period Time 1 min
        statistic        = "Max"
        time_window      = "PT10M" // 持續時間: Period Time 5 min
        time_aggregation = "Average"
        operator         = "GreaterThan"
        threshold        = 70
        metric_namespace = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M" // 冷靜: Period Time 10 min
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.default.id

        time_grain       = "PT1M" // 粒度: Period Time 1 min
        statistic        = "Average"
        time_window      = "PT15M" // 持續時間: Period Time 15 min
        time_aggregation = "Average"
        operator         = "LessThan"
        threshold        = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT30M"
      }
    }
  }

  notification {
    email {
      custom_emails                         = local.notify_emails
      send_to_subscription_administrator    = false
      send_to_subscription_co_administrator = true
    }
  }

  tags = {
    CreatedBy = "Terraform"
  }

  lifecycle {
    ignore_changes = []
  }
}
