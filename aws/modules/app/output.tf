output "lb_id" {
  value = aws_lb.default.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.default.name
}
