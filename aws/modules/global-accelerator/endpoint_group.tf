resource "aws_globalaccelerator_endpoint_group" "udp53" {
  for_each     = { for region in var.regions : region.name => region }
  listener_arn = aws_globalaccelerator_listener.udp53.id

  endpoint_group_region = each.key

  dynamic "endpoint_configuration" {
    for_each = each.value.endpoints
    content {
      client_ip_preservation_enabled = true
      endpoint_id                    = endpoint_configuration.value.id
      weight                         = endpoint_configuration.value.weight
    }
  }

  health_check_port             = 53
  health_check_protocol         = "TCP"
  health_check_interval_seconds = 30
  threshold_count               = 3
}

resource "aws_globalaccelerator_endpoint_group" "tcp53_10050" {
  for_each     = { for region in var.regions : region.name => region }
  listener_arn = aws_globalaccelerator_listener.tcp53_10050.id

  endpoint_group_region = each.key

  dynamic "endpoint_configuration" {
    for_each = each.value.endpoints
    content {
      client_ip_preservation_enabled = true
      endpoint_id                    = endpoint_configuration.value.id
      weight                         = endpoint_configuration.value.weight
    }
  }

  health_check_port             = 53
  health_check_protocol         = "TCP"
  health_check_interval_seconds = 30
  threshold_count               = 3
}
