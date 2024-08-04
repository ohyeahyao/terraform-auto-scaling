locals {
  vpc_name = "pdns-vpc"
}

module "network" {
  source = "../modules/network"

  vpc = {
    name = local.vpc_name
    cidr = "10.1.0.0/16"
  }

  internet_gateway_name = lower("${local.vpc_name}-igw")

  subnets = [
    {
      name    = lower("${local.vpc_name}-euc1-az1-subnet")
      cidr    = "10.1.0.0/20"
      zone_id = "euc1-az1"
    },
    {
      name    = lower("${local.vpc_name}-euc1-az2-subnet")
      cidr    = "10.1.16.0/20"
      zone_id = "euc1-az2"
    },
    {
      name    = lower("${local.vpc_name}-euc1-az3-subnet")
      cidr    = "10.1.32.0/20"
      zone_id = "euc1-az3"
    }
  ]
}
