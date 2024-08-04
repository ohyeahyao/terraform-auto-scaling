provider "aws" {
  alias      = "sae1"
  region     = "sa-east-1"
  access_key = local.tf_credential.AccessKeyId
  secret_key = local.tf_credential.SecretAccessKey
}

data "aws_lb" "prod_sae1_pdns_1_lb" {
  provider = aws.sae1

  arn  = "arn:aws:elasticloadbalancing:sa-east-1:632438852715:loadbalancer/net/prod-sae1-pdns-1-lb/9c7650875fbfda48"
  name = "prod-sae1-pdns-1-lb"
}

