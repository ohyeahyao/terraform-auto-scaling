provider "aws" {
  alias      = "aps1"
  region     = "ap-southeast-1"
  access_key = local.tf_credential.AccessKeyId
  secret_key = local.tf_credential.SecretAccessKey
}

data "aws_lb" "prod_pdns_sg_1_lb" {
  provider = aws.aps1

  arn  = "arn:aws:elasticloadbalancing:ap-southeast-1:632438852715:loadbalancer/net/prod-pdns-sg-1-lb/dfdfab7afb881a67"
  name = "prod-pdns-sg-1-lb"
}

