resource "aws_lb" "tfe" {
  name_prefix                      = "tfe-" # using hardcoded prefix because of length limitatoin to 6 chars
  load_balancer_type               = "network"
  internal                         = var.lb_internal
  subnets                          = module.tfe-network.public_subnet_ids
  enable_cross_zone_load_balancing = true
  tags                             = var.common_tags

  depends_on = [
    module.tfe-network # ensure that the underlying network resources are fully created before creating the balancer.
  ]
}

resource "aws_lb_listener" "port_80" {
  load_balancer_arn = aws_lb.tfe.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.port_80.arn
  }
}

resource "aws_lb_listener" "port_443" {
  load_balancer_arn = aws_lb.tfe.arn
  port              = 443
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.port_443.arn
  }
}

resource "aws_lb_listener" "port_8800" {
  load_balancer_arn = aws_lb.tfe.arn
  port              = 8800
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.port_8800.arn
  }
}

resource "aws_lb_target_group" "port_80" {
  name     = "${var.name_prefix}port-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = module.tfe-network.vpc_id

  health_check {
    protocol            = "HTTP"
    port                = 80
    path                = "/"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "port_443" {
  name     = "${var.name_prefix}port-443"
  port     = 443
  protocol = "TCP"
  vpc_id   = module.tfe-network.vpc_id

  health_check {
    protocol            = "HTTPS"
    port                = 443
    path                = "/_health_check"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "port_8800" {
  name     = "${var.name_prefix}port-8800"
  port     = 8800
  protocol = "TCP"
  vpc_id   = module.tfe-network.vpc_id
}