locals {
  vip_launch_template = {
    hostname_prefix = "prod-sg-vip-pdns-aws"
    instance_type   = "c5.2xlarge",
    image_version   = "PDNS-1.4.0-20230320"
  }
}

data "aws_ami" "vip_image" {
  owners      = ["self"]
  most_recent = true
  name_regex  = local.vip_launch_template.image_version
}

module "vip_launch_template" {
  source = "../modules/launch_template"

  security_group_id = module.security_group.security_group.id

  launch_template = {
    name            = "prod-sg-vip-pdns-LT"
    instance_type   = local.vip_launch_template.instance_type
    image_id        = data.aws_ami.vip_image.image_id
    hostname_prefix = local.vip_launch_template.hostname_prefix
  }

  key_name = module.ssh_key.name
}
