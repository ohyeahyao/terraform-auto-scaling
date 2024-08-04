locals {
  user_data = replace(file("${path.module}/files/cloud-init.txt"), "__HOSTNAME_PREFIX__", var.launch_template.hostname_prefix)
}
resource "aws_launch_template" "default" {
  name = var.launch_template.name

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 50
      encrypted   = "true"
    }
  }


  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }
  update_default_version = true
  image_id               = var.launch_template.image_id

  instance_type = var.launch_template.instance_type

  key_name = var.key_name

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "pdns-tf-autoscaling"
      CreatedBy = "Terraform"
    }
  }

  user_data = base64encode(local.user_data)
}
