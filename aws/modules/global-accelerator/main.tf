resource "aws_globalaccelerator_accelerator" "default" {
  name            = var.name
  ip_address_type = "IPV4"
  enabled         = true

  tags = merge(
    var.tags,
    {
      App       = "PDNS"
      CreatedBy = "Terraform"
    }
  )
}

resource "aws_globalaccelerator_listener" "udp53" {
  accelerator_arn = aws_globalaccelerator_accelerator.default.id
  client_affinity = "NONE" # five-tuple
  protocol        = "UDP"

  port_range {
    from_port = 53
    to_port   = 53
  }
}

resource "aws_globalaccelerator_listener" "tcp53_10050" {
  accelerator_arn = aws_globalaccelerator_accelerator.default.id
  client_affinity = "NONE" # five-tuple
  protocol        = "TCP"

  port_range {
    from_port = 53
    to_port   = 53
  }
  port_range {
    from_port = 10050
    to_port   = 10050
  }
}
