variable "common_tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
  default     = {}
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the s3 bucket to create."
}

variable "s3_bucket_region" {
  type        = string
  description = "The AWS region in which to create the s3 bucket."
}

variable "s3_force_delete" {
  type        = bool
  description = "Whether all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error."
  default     = true
}
