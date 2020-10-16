resource "aws_instance" "ssh_hop" {
  count                       = var.enable ? 1 : 0
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = aws_security_group.ssh_hop[*].id
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = merge({
    "Name" = "${var.name_prefix}ssh-hop"
    },
  var.common_tags)
}

resource "aws_security_group" "ssh_hop" {
  count       = var.enable ? 1 : 0
  name        = "${var.name_prefix}ssh-hop-instance"
  description = "Allow incomming SSH traffic."
  vpc_id      = var.vpc_id
  tags        = var.common_tags
}

resource "aws_security_group_rule" "allow_ssh" {
  count             = var.enable ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = coalescelist(var.allow_ingress_cirds, ["0.0.0.0/0"])
  security_group_id = aws_security_group.ssh_hop[0].id
}

resource "aws_security_group_rule" "allow_all_outbound" {
  count             = var.enable ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ssh_hop[0].id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}