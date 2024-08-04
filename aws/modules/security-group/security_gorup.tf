resource "aws_security_group" "default" {
  name        = var.security_group.name
  description = "Security Group for PDNS"
  vpc_id      = var.vpc_id


  ingress {
    description = "in Security Group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    prefix_list_ids = [
      aws_ec2_managed_prefix_list.allow_ssh_list.id
    ]
  }

  ingress {
    description = "Zabbix Ingress"
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    prefix_list_ids = [
      aws_ec2_managed_prefix_list.zabbix_ips.id
    ]
  }

  ingress {
    description = "TCP:53"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-ingress-sgr
  }

  ingress {
    description = "UDP:53"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = var.security_group.name
    CreatedBy = "Terraform"
  }
}
