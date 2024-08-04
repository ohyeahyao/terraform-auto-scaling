locals {
  allow_ssh_IPs = [
    # { cidr : "59.124.115.31/32", description : "公司IP" },
    # { cidr : "59.124.115.32/32", description : "公司IP" },
    # { cidr : "59.124.115.33/32", description : "公司IP" },
    { cidr : "59.124.115.147/32", description : "SOC Room IP" },
    { cidr : "59.124.115.148/32", description : "SOC Room IP" },
    { cidr : "59.124.115.225/32", description : "公司IP" },
    { cidr : "35.194.232.181/32", description : "VPN" },
    { cidr : "35.187.153.14/32", description : "Prod Zabbix Server" },
    { cidr : "47.52.237.32/32", description : "Prod Zabbix Proxy" },
    { cidr : "35.185.149.71/32", description : "Jump1" },
    { cidr : "47.101.45.217/32", description : "Jump2" }
  ]
  zabbix_IPs_data = {
    "prod" = [
      { cidr : "47.52.237.32/32", description : "Prod Zabbix Proxy" },
      { cidr : "35.187.153.14/32", description : "Prod Zabbix Server" },
      { cidr : "47.115.1.225/32", description : "prod-hk-zabbix-proxy-1" },
    ],
    "uat" = [
      { cidr : "34.80.43.213/32", description : "Zabbix-UAT" },
    ]
  }
  zabbix_IPs = local.zabbix_IPs_data[var.env]
}

resource "aws_ec2_managed_prefix_list" "allow_ssh_list" {
  name           = "Allow-SSH-IPs"
  address_family = "IPv4"
  max_entries    = 15

  dynamic "entry" {
    for_each = local.allow_ssh_IPs
    content {
      cidr        = entry.value.cidr
      description = entry.value.description
    }
  }

  tags = {
    Port      = "22",
    CreatedBy = "Terraform"
  }
}

resource "aws_ec2_managed_prefix_list" "zabbix_ips" {
  name           = "Zabbix-IPs"
  address_family = "IPv4"
  max_entries    = 10

  dynamic "entry" {
    for_each = local.zabbix_IPs
    content {
      cidr        = entry.value.cidr
      description = entry.value.description
    }
  }

  tags = {
    Protocol_Port = "TCP:10050",
    CreatedBy     = "Terraform"
  }
}
