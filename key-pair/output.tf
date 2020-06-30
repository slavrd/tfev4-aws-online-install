output "key_pair_name" {
  value       = var.key_pair_create ? aws_key_pair.key[0].key_name : ""
  description = "Name of the created AWS key pair."
}

output "private_key" {
  value = var.key_pair_create && var.public_key == "" ? tls_private_key.key_pair[0].private_key_pem : ""
}

output "public_key" {
  value = var.key_pair_create ? aws_key_pair.key[0].public_key : ""
}