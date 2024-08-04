module "prod_fra_pdns_1" {
  source = "../modules/app"

  vpc_id               = module.network.vpc.id
  lb_security_group_id = module.security_group.lb_security_group.id

  use_mixed_instances_policy = true
  mixed_instances_policy = {
    spot_allocation_strategy = "price-capacity-optimized"
    on_demand_base_capacity  = 1
    spot_instance_pools      = 0
    override = [
      {
        instance_type = "c6a.large"
        weight        = "1"
      },
      {
        instance_type = "c5a.large"
        weight        = "1"
      },
      {
        instance_type = "c5n.large"
        weight        = "1"
      },
      {
        instance_type = "c5d.large"
        weight        = "1"
      },
      {
        instance_type = "c6i.large"
        weight        = "1"
      },
      {
        instance_type = "c4.large"
        weight        = "1"
      },
      {
        instance_type = "c3.large"
        weight        = "1"
      }
    ]
  }
  autoscaling_group = {
    name               = "prod-fra-pdns-1"
    launch_template_id = module.launch_template.launch_template_id
    subnet_ids         = [for subnet_id in module.network.subnet_ids : subnet_id]
    instance_count     = 1
    capacity = {
      min = 1
      max = 10
    }
  }

  simple_scale_in = {
    threshold          = "15"
    evaluation_periods = "5"
    period             = "60"
  }

  simple_scale_out = {
    threshold          = "30"
    evaluation_periods = "2"
    period             = "60"
  }

  scale_out_max = {
    threshold          = "45"
    evaluation_periods = "5"
    period             = "60"
  }
}
