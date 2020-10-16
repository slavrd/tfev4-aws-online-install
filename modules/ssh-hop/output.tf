output "public_ip" {
  description = "Public IP of the EC2 instance."
  value       = var.enable ? aws_instance.ssh_hop[0].public_ip : ""
}

output "public_dns" {
  description = "Public DNS of the EC2 instance."
  value       = var.enable ? aws_instance.ssh_hop[0].public_dns : ""
}