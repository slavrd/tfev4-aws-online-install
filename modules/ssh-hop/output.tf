output "public_ip" {
  description = "Public IP of the EC2 instance."
  value       = aws_instance.ssh_hop.public_ip
}

output "public_dns" {
  description = "Public DNS of the EC2 instance."
  value       = aws_instance.ssh_hop.public_dns
}