output "tfe_address" {
  value       = "https://${var.tfe_hostname}"
  description = "Address for accessing the tfe instance."
}

output "replicated_address" {
  value       = "https://${var.tfe_hostname}:8800"
  description = "Address for accessing the replicate console."
}

output "private_key" {
  value       = var.key_pair_create ? module.key_pair.private_key : ""
  description = "The private key of the TLS key pair if such was created."
}

output "ssh_hop_public_ip" {
  value       = var.create_ssh_hop ? module.ssh_hop[0].public_ip : ""
  description = "The public IP address of the SSH hop if such was created."
}

output "lb_dns" {
  value       = module.network.lb_dns_name
  description = "The DNS of the Network Load Balancer if front of the TFE instance."
}