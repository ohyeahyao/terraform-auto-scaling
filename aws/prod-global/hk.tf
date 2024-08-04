provider "aws" {
  alias      = "hk"
  region     = "ap-east-1"
  access_key = local.tf_credential.AccessKeyId
  secret_key = local.tf_credential.SecretAccessKey
}


data "aws_lb" "prod_pdns_hk_2_lb" {
  provider = aws.hk

  arn  = "arn:aws:elasticloadbalancing:ap-east-1:632438852715:loadbalancer/net/prod-pdns-hk-2-lb/aa7f2ac20b98d82b"
  name = "prod-pdns-hk-2-lb"
}

data "aws_lb" "prod_hk_vip_pdns_2_lb" {
  provider = aws.hk

  arn  = "arn:aws:elasticloadbalancing:ap-east-1:632438852715:loadbalancer/net/prod-hk-vip-pdns-2-lb/4a186d11b89d1f67"
  name = "prod-hk-vip-pdns-2-lb"
}
