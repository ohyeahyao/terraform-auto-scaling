locals {
  launch_template = {
    hostname_prefix = "prod-fra-pdns-aws"
    instance_type   = "c6a.large",
    image_version   = "PDNS-2.2.0-2023.1103.1032"
  }
}

data "aws_ami" "image" {
  owners      = ["self"]
  most_recent = true
  name_regex  = local.launch_template.image_version
}

module "launch_template" {
  source = "../modules/launch_template"

  security_group_id = module.security_group.security_group.id

  launch_template = {
    name            = "prod-fra-pdns-LT"
    instance_type   = local.launch_template.instance_type
    image_id        = data.aws_ami.image.image_id
    hostname_prefix = local.launch_template.hostname_prefix
  }

  key_name = module.ssh_key.name
}
