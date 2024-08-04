resource "aws_security_group" "lb_default" {
  name        = "${var.security_group.name}-lb"
  description = "Security Group for Load Balancer"
  vpc_id      = var.vpc_id


  ingress {
    description = "in Security Group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
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
    description     = "UDP:53"
    from_port       = 53
    to_port         = 53
    protocol        = "udp"
    security_groups = [aws_security_group.default.id]
  }

  egress {
    description = "TCP:53"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"

    security_groups = [aws_security_group.default.id]
  }

  tags = {
    Name      = "${var.security_group.name}-lb"
    CreatedBy = "Terraform"
  }
}
