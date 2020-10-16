variable "ami_id" {
  type        = string
  description = "The AMI Id to use for the tfe instance. Needs to have the TFE arigap package and Replicated installer."
}

variable "key_name" {
  type        = string
  description = "Name of the AWS key pair to use for the tfe instance."
}

variable "key_pair_create" {
  type        = bool
  description = "Wether to create an AWS key pair at all. If false the key_name variable must be set to an existing aws ec2 key pair."
  default     = false
}

variable "public_key_path" {
  type        = string
  description = "Public key to use for the AWS key pair creation. If not provided a new TLS public/private key pair will be generated."
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "The AWS instance type to use."
  default     = "m5a.large"
}

variable "root_block_device_size" {
  type        = number
  description = "The size of the root block device volume in gigabytes."
  default     = 50
}

variable "health_check_type" {
  type        = string
  description = "Sets the healthcheck type for the auto scaling group. Accepted values ELB, EC2."
  default     = "ELB"
}

variable "tfe_associate_public_ip_address" {
  type        = bool
  description = "Wether to associate public ip address with the isntance. Shold be false except if bringin a standalone instance for testing."
  default     = false
}

variable "ingress_cidrs_http" {
  type        = list(string)
  description = "CIDRs from which HTTP/HTTPS ingress traffic to the TFE instance is allowed."
  default     = ["0.0.0.0/0"]
}

variable "ingress_cidrs_replicated_dashboard" {
  type        = list(string)
  description = "CIDRs from which ingress traffic to the TFE instance is allowed."
  default     = ["0.0.0.0/0"]
}

variable "asg_lifecycle_hook_default_result" {
  type        = string
  description = "Sets the default action for the Auto Scaling group inital lifecycle hook. Can be ABANDON or CONTINUE."
  default     = "ABANDON"
}
