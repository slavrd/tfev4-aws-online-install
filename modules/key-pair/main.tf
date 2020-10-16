resource "tls_private_key" "key_pair" {
  count     = var.key_pair_create && var.public_key == "" ? 1 : 0
  algorithm = "RSA"
}

resource "aws_key_pair" "key" {
  count      = var.key_pair_create ? 1 : 0
  key_name   = var.key_name
  public_key = var.public_key != "" ? var.public_key : tls_private_key.key_pair[0].public_key_openssh
}