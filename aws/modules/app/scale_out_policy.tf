resource "aws_autoscaling_policy" "simple_scale_out" {
  name                   = "simple_scale_out"
  autoscaling_group_name = aws_autoscaling_group.default.name
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "simple_scale_out" {
  alarm_description   = "Monitors CPU utilization for ${aws_autoscaling_group.default.name}"
  alarm_actions       = [aws_autoscaling_policy.simple_scale_out.arn]
  alarm_name          = lower("${aws_autoscaling_group.default.name}_scale_out")
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = var.simple_scale_out.threshold
  evaluation_periods  = var.simple_scale_out.evaluation_periods
  period              = var.simple_scale_out.period
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.default.name
  }
}
