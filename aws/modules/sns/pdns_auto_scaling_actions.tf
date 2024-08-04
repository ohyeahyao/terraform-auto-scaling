resource "aws_sns_topic" "general" {
  name = "pdns_auto_scaling_actions"
}

resource "aws_autoscaling_notification" "general_notifications" {
  group_names = var.general_autoscaling_group.names

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.general.arn
}

resource "aws_sns_topic_subscription" "general_email_subscription" {
  for_each = toset(var.general_autoscaling_group.emails)

  topic_arn = aws_sns_topic.general.arn
  protocol  = "email"
  endpoint  = each.key
}
