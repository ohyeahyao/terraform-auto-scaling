provider "aws" {
  alias      = "use1"
  region     = "us-east-1"
  access_key = local.tf_credential.AccessKeyId
  secret_key = local.tf_credential.SecretAccessKey
}

data "aws_lb" "prod_use1_pdns_1_lb" {
  provider = aws.use1

  arn  = "arn:aws:elasticloadbalancing:us-east-1:632438852715:loadbalancer/net/prod-ues1-pdns-1-lb/5c7cbdf2ec4e12e3"
  name = "prod-ues1-pdns-1-lb"
}

