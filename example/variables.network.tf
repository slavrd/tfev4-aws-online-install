variable "vpc_cidr_block" {
  type        = string
  description = "CIDR for the VPC to create."
}

variable "public_subnets_cidrs" {
  type = list(object({
    cidr     = string
    az_index = number
  }))
  description = "List of objects representing the public subnets CIDRs and their availability zones. The az_index property is used as an index to retrieve a zone from the list of the availability zones for the current AWS region."
}

variable "private_subnets_cidrs" {
  type = list(object({
    cidr     = string
    az_index = number
  }))
  default     = []
  description = "List of objects representing the private subnets CIDRs and their availability zones. The az_index property is used as an index to retrieve a zone from the list of the availability zones for the current AWS region."
}

variable "lb_internal" {
  type        = bool
  description = "Whether to create internal load balancer."
  default     = false
}
