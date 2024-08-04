resource "aws_lb" "default" {
  name               = "${var.autoscaling_group.name}-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.autoscaling_group.subnet_ids

  security_groups = [
    var.lb_security_group_id
  ]

  enable_cross_zone_load_balancing = false
}

resource "aws_lb_target_group" "tcp_udp53_tg" {
  name     = "${var.autoscaling_group.name}-53-tg"
  port     = 53
  protocol = "TCP_UDP"
  vpc_id   = var.vpc_id

  connection_termination = true
  deregistration_delay   = 180

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    protocol            = "TCP"
  }
}

resource "aws_autoscaling_attachment" "tcp_udp53_attachemnt" {
  autoscaling_group_name = aws_autoscaling_group.default.id
  lb_target_group_arn    = aws_lb_target_group.tcp_udp53_tg.arn
}

resource "aws_lb_listener" "tcp_udp53_listener" {
  load_balancer_arn = aws_lb.default.arn
  port              = "53"
  protocol          = "TCP_UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tcp_udp53_tg.arn
  }
}

