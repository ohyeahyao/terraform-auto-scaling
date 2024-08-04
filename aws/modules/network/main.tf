resource "aws_vpc" "default" {
  cidr_block       = var.vpc.cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc.name
  }
}

/**
* $ aws ec2 describe-availability-zones --region ${REGION}
*/
resource "aws_subnet" "default" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  vpc_id               = aws_vpc.default.id
  cidr_block           = each.value.cidr
  availability_zone_id = each.value.zone_id

  tags = {
    Name = each.value.name
  }
}

