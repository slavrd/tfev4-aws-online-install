variable "vpc_cidr_block" {
  type        = string
  description = "CIDR for the VPC to create."
}

variable "public_subnets_cidrs" {
  type = list(object({
    cidr     = string
    az_index = number
  }))
  description = "List of objects reprisenting the public subnets CIDRs and their availability zones. The az_index property is used as an index to retireve a zone from the list of the availability zones for the current AWS region."
}

variable "private_subnets_cidrs" {
  type = list(object({
    cidr     = string
    az_index = number
  }))
  default     = []
  description = "List of objects reprisenting the private subnets CIDRs and their availability zones. The az_index property is used as an index to retireve a zone from the list of the availability zones for the current AWS region."
}

variable "lb_internal" {
  type        = bool
  description = "Whether to create internal load balancer."
  default     = false
}

variable "name_prefix" {
  type        = string
  description = "A string to be used as prefix for generating names of the created resources"
  default     = "tfe-"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to assign to all resources"
  default     = {}
}