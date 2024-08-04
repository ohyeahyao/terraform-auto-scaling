provider "aws" {
  alias      = "fra"
  region     = "eu-central-1"
  access_key = local.tf_credential.AccessKeyId
  secret_key = local.tf_credential.SecretAccessKey
}

data "aws_lb" "prod_fra_pdns_1_lb" {
  provider = aws.fra

  arn  = "arn:aws:elasticloadbalancing:eu-central-1:632438852715:loadbalancer/net/prod-fra-pdns-1-lb/bfd05f8eb827fc14"
  name = "prod-fra-pdns-1-lb"
}

