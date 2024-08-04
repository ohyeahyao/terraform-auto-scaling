resource "aws_autoscaling_policy" "simple_scale_in" {
  name                   = "simple_scale_in"
  autoscaling_group_name = aws_autoscaling_group.default.name
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = -1
  cooldown               = 600
}

resource "aws_cloudwatch_metric_alarm" "simple_scale_in" {
  alarm_description   = "Monitors CPU utilization for Terramino ASG"
  alarm_actions       = [aws_autoscaling_policy.simple_scale_in.arn]
  alarm_name          = lower("${aws_autoscaling_group.default.name}_scale_in")
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = var.simple_scale_in.threshold
  evaluation_periods  = var.simple_scale_in.evaluation_periods
  period              = var.simple_scale_in.period
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.default.name
  }
}
