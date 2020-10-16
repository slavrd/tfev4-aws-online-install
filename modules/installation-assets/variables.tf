variable "s3_bucket_name" {
  type        = string
  description = "Name of the s3 bucket to create."
}

variable "s3_force_delete" {
  type        = bool
  description = "Whether all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error."
  default     = true
}

variable "tfe_certificate_path" {
  type        = string
  description = "Path to the local file containing the SSL certificate to upload to the S3 bucket."
}

variable "tfe_certificate_key_path" {
  type        = string
  description = "Path to the local file containing the SSL certificate private key to upload to the S3 bucket."
}

variable "tfe_license_path" {
  type        = string
  description = "Path to the local file containing the TFE license to upload to the S3 bucket."
}

variable "create" {
  type        = bool
  description = "Whether to create the module resources."
  default     = true
}

variable "common_tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
  default     = {}
}