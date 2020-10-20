variable "create_ssh_hop" {
  type        = bool
  description = "Whether to create an EC2 instance and related resources to be used as a SSH hop."
  default     = false
}

variable "ssh_ingress_cidrs" {
  type        = list(string)
  description = "List of CIDRs from which incoming SSH connections are allowed. If the list is empty 0.0.0.0/0 will be used."
  default     = []
}
