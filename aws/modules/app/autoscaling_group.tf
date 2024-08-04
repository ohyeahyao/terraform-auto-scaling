resource "aws_autoscaling_group" "default" {
  name = var.autoscaling_group.name

  vpc_zone_identifier = var.autoscaling_group.subnet_ids

  desired_capacity = var.autoscaling_group.instance_count
  min_size         = var.autoscaling_group.capacity.min
  max_size         = var.autoscaling_group.capacity.max

  health_check_grace_period = 180
  health_check_type         = "ELB"

  capacity_rebalance = true

  # NOTE on Auto Scaling Groups and ASG Attachments:
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
  lifecycle {
    ignore_changes = [target_group_arns, desired_capacity]
  }

  dynamic "launch_template" {
    for_each = var.use_mixed_instances_policy ? [] : [1]

    content {
      id      = var.autoscaling_group.launch_template_id
      version = "$Default"
    }
  }

  dynamic "mixed_instances_policy" {
    for_each = var.use_mixed_instances_policy ? [var.mixed_instances_policy] : []
    content {
      instances_distribution {
        on_demand_allocation_strategy            = "prioritized"
        on_demand_base_capacity                  = coalesce(var.mixed_instances_policy.on_demand_base_capacity, 1)
        on_demand_percentage_above_base_capacity = 0
        spot_allocation_strategy                 = coalesce(var.mixed_instances_policy.spot_allocation_strategy, "lowest-price")
        spot_instance_pools                      = coalesce(var.mixed_instances_policy.spot_instance_pools, 0)
      }

      launch_template {
        launch_template_specification {
          launch_template_id = var.autoscaling_group.launch_template_id
          version            = "$Default"
        }
        dynamic "override" {
          for_each = try(mixed_instances_policy.value.override, [])
          content {
            instance_type     = try(override.value.instance_type, null)
            weighted_capacity = try(override.value.weight, null)
          }
        }
      }
    }
  }

  enabled_metrics = [
    "GroupAndWarmPoolDesiredCapacity",
    "GroupAndWarmPoolTotalCapacity",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
    "WarmPoolDesiredCapacity",
    "WarmPoolMinSize",
    "WarmPoolPendingCapacity",
    "WarmPoolTerminatingCapacity",
    "WarmPoolTotalCapacity",
    "WarmPoolWarmedCapacity",
  ]
}
