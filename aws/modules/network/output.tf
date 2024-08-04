output "vpc" {
  value = {
    id = aws_vpc.default.id
  }
}

output "subnet_ids" {
  value = { for k, subnet in aws_subnet.default : k => subnet.id }
}
