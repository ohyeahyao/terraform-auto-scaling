resource "aws_autoscaling_policy" "scale_out_max" {
  name                   = "scale_out_max"
  autoscaling_group_name = aws_autoscaling_group.default.name
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "scale_out_max" {
  alarm_description   = "Monitors Max CPU utilization for ${aws_autoscaling_group.default.name}"
  alarm_actions       = [aws_autoscaling_policy.scale_out_max.arn]
  alarm_name          = lower("${aws_autoscaling_group.default.name}_scale_out_max")
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = var.scale_out_max.threshold
  evaluation_periods  = var.scale_out_max.evaluation_periods
  period              = var.scale_out_max.period
  statistic           = "Maximum"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.default.name
  }
}


