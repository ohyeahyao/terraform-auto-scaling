provider "aws" {
  alias      = "jp"
  region     = "ap-northeast-1"
  access_key = local.tf_credential.AccessKeyId
  secret_key = local.tf_credential.SecretAccessKey
}

data "aws_lb" "prod_jp_pdns_1_lb" {
  provider = aws.jp

  arn  = "arn:aws:elasticloadbalancing:ap-northeast-1:632438852715:loadbalancer/net/prod-jp-pdns-1-lb/3cf952550b2ae963"
  name = "prod-jp-pdns-1-lb"
}

