output "tfe_address" {
  value       = "https://${var.tfe_hostname}"
  description = "Address for accessing the tfe instance"
}

output "replicated_address" {
  value       = "https://${var.tfe_hostname}:8800"
  description = "Address for accessing the replicate console"
}

output "private_key" {
  value       = var.key_pair_create ? module.key_pair.private_key : ""
  description = "The private key of the TLS key pair if such was created."
}

output "ssh_hop_public_ip" {
  value = coalesce(module.ssh_hop.public_ip, "n/a")
}