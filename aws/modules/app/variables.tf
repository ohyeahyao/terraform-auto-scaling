variable "vpc_id" {
  type = string
}

variable "lb_security_group_id" {
  type = string
}

variable "use_mixed_instances_policy" {
  description = "Determines whether to use a mixed instances policy in the autoscaling group or not"
  type        = bool
  default     = false
}

variable "mixed_instances_policy" {
  type = object({
    spot_allocation_strategy = string
    on_demand_base_capacity  = number
    spot_instance_pools      = number
    override = list(object({
      instance_type = string
      weight        = string
    }))
  })
  default     = null
  description = "Infomation of Subnets"
}

variable "autoscaling_group" {
  type = object({
    name               = string
    launch_template_id = string
    subnet_ids         = list(string)
    instance_count     = number
    capacity = object({
      min = number
      max = number
    })
  })
}

variable "simple_scale_in" {
  type = object({
    threshold          = string
    evaluation_periods = string
    period             = string
  })
}

variable "simple_scale_out" {
  type = object({
    threshold          = string
    evaluation_periods = string
    period             = string
  })
}

variable "scale_out_max" {
  type = object({
    threshold          = string
    evaluation_periods = string
    period             = string
  })
}
