resource "aws_security_group" "tfe_instance" {
  name        = "${var.name_prefix}tfe-instance"
  description = "Allow needed needed traffic for tfe."
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidrs_http
  security_group_id = aws_security_group.tfe_instance.id
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidrs_http
  security_group_id = aws_security_group.tfe_instance.id
}

resource "aws_security_group_rule" "allow_https_self" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.tfe_instance.id
  security_group_id        = aws_security_group.tfe_instance.id
}

resource "aws_security_group_rule" "replicated_dashboard" {
  type              = "ingress"
  from_port         = 8800
  to_port           = 8800
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidrs_replicated_dashboard
  security_group_id = aws_security_group.tfe_instance.id
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidrs_ssh
  security_group_id = aws_security_group.tfe_instance.id
}

resource "aws_security_group_rule" "sg_local_1" {
  type                     = "ingress"
  from_port                = 9870
  to_port                  = 9880
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.tfe_instance.id
  security_group_id        = aws_security_group.tfe_instance.id
}

resource "aws_security_group_rule" "sg_local_2" {
  type                     = "ingress"
  from_port                = 23000
  to_port                  = 23100
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.tfe_instance.id
  security_group_id        = aws_security_group.tfe_instance.id
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.tfe_instance.id
}