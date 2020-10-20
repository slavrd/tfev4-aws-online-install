resource "aws_instance" "ssh_hop" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ssh_hop.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data_base64 = base64encode(templatefile("${path.module}/templates/cloud-init.tmpl", {
    ssh_keys = var.ssh_private_keys
  }))

  tags = merge({
    "Name" = "${var.name_prefix}ssh-hop"
    },
  var.common_tags)
}

resource "aws_security_group" "ssh_hop" {
  name        = "${var.name_prefix}ssh-hop-instance"
  description = "Allow incomming SSH traffic."
  vpc_id      = var.vpc_id
  tags        = var.common_tags
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = coalescelist(var.allow_ingress_cirds, ["0.0.0.0/0"])
  security_group_id = aws_security_group.ssh_hop.id
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ssh_hop.id
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