module "anycast-vip-pdns" {
  source = "../modules/global-accelerator"

  name = "anycast-mjb-pdns" // vip

  regions = [
    // 香港
    {
      name = "ap-east-1"
      endpoints = [
        {
          id     = data.aws_lb.prod_hk_vip_pdns_2_lb.id
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
