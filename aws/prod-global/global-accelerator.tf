locals {
  const_endpoint_type = {
    lb = "lb",
    vm = "vm"
  }
}
module "anycast-pdns" {
  source = "../modules/global-accelerator"

  name = "anycast-pdns"

  regions = [
    // 南美洲 (聖保羅)
    {
      name = "sa-east-1"
      endpoints = [
        {
          id     = data.aws_lb.prod_sae1_pdns_1_lb.id
          type   = local.const_endpoint_type.lb
          weight = 128
        }
      ]
    },
    // 亞太地區 (香港)
    {
      name = "ap-east-1"
      endpoints = [
        {
          id     = data.aws_lb.prod_pdns_hk_2_lb.id
          type   = local.const_endpoint_type.lb
          weight = 128
        }
      ]
    },
    // 美國東部 (維吉尼亞州北部)
    {
      name = "us-east-1"
      endpoints = [
        {
          id     = data.aws_lb.prod_use1_pdns_1_lb.id
          type   = local.const_endpoint_type.lb
          weight = 128
        }
      ]
    },
    // 歐洲 (法蘭克福)
    {
      name = "eu-central-1"
      endpoints = [
        {
          id     = data.aws_lb.prod_fra_pdns_1_lb.id
          type   = local.const_endpoint_type.lb
          weight = 128
        }
      ]
    },
    // 亞太地區 (新加坡)
    {
      name = "ap-southeast-1"
      endpoints = [
        {
          id     = data.aws_lb.prod_pdns_sg_1_lb.id
          type   = local.const_endpoint_type.lb
          weight = 128
        }
      ]
    },
    // 亞太地區 (東京)
    {
      name = "ap-northeast-1"
      endpoints = [
        {
          id     = data.aws_lb.prod_jp_pdns_1_lb.id
          type   = local.const_endpoint_type.lb
          weight = 128
        }
      ]
    },
  ]

  tags = {
    Name = "anycast"
  }
}
