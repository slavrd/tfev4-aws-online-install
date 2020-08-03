variable "vpc_id" {
  type        = string
  description = "Id of the VPC in which to deploy the TFE instance."
}

variable "subnets_ids" {
  type        = list(string)
  description = "List of subnet ids in which to create TFE instance."
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

variable "ingress_cidrs_ssh" {
  type        = list(string)
  description = "CIDRs from which ingress traffic to the TFE instance is allowed."
  default     = ["0.0.0.0/0"]
}

variable "ami_id" {
  type        = string
  description = "The AMI Id to use for the TFE instance."
}

variable "key_name" {
  type        = string
  description = "Name of the AWS key pair to use for the TFE instance."
}

variable "common_tags" {
  type        = map(string)
  description = "The common tags to use with the managed resources. The default vaule is used as an example."
  default = {
    owner   = ""
    project = ""
  }
}

variable "instance_type" {
  type        = string
  description = "The AWS instance type to use."
  default     = "m5a.large"
}

variable "name_prefix" {
  type        = string
  description = "Name prefix to use when creating names for resources."
  default     = "tfev4-"
}

variable "root_block_device_size" {
  type        = number
  description = "The size of the root block device volume in gigabytes"
  default     = 50
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Wether to associate public ip address with the isntance. Shold be false except if bringin a standalone instance for testing."
  default     = false
}

variable "target_groups_arns" {
  type        = list(string)
  description = "List of target group arns in which to register the auto scaling group instances."
}

variable "health_check_type" {
  type        = string
  description = "Sets the healthcheck type for the auto scaling group. Accepted values ELB, EC2."
  default     = "ELB"
}

variable "asg_lifecycle_hook_default_result" {
  type        = string
  description = "Sets the default action for the Auto Scaling group inital lifecycle hook. Can be ABANDON or CONTINUE."
  default     = "ABANDON"
}
