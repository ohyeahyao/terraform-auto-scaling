output "security_group" {
  value = {
    id = aws_security_group.default.id
  }
}

output "lb_security_group" {
  value = {
    id = aws_security_group.lb_default.id
  }
}
