variable "aws_region" {
  type        = string
  description = "The AWS region to use."
}

variable "name_prefix" {
  type        = string
  description = "A string to be used as prefix for generating names of the created resources."
  default     = "tfe-"
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the s3 buckut which will be used for starge by TFE.."
}

variable "installation_assets_s3_bucket_name" {
  type        = string
  description = "Name of the s3 bucket to create and put the installation assets in."
}

variable "tfe_certificate_path" {
  type        = string
  description = "Path to the local file containg the SSL certificate to upload to the S3 bucket."
}

variable "tfe_certificate_key_path" {
  type        = string
  description = "Path to the local file containg the SSL certificate private key to upload to the S3 bucket."
}

variable "tfe_license_path" {
  type        = string
  description = "Path to the local file containg the TFE license to upload to the S3 bucket."
}

variable "tfe_ca_bundle_path" {
  type        = string
  description = "Path to the file containing additional Root CA certifiates which TFE should use."
  default     = ""
}

variable "replicated_password" {
  type        = string
  description = "Password to set for the replaicated console."
}

variable "tfe_hostname" {
  type        = string
  description = "Hostname which will be used to access the tfe instance."
}

variable "tfe_enc_password" {
  type        = string
  description = "Encryption password to be used by tfe."
}

variable "tfe_release_sequence" {
  type        = number
  description = "The realese sequence corresponding to the TFE version which should be installed."
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to assign to all resources."
  default     = {}
}

variable "create_dns_record" {
  type        = bool
  description = "Weather to create a DNS record for the TFC hostame. If enabled the hostname must be in a zone hosted in AWS."
  default     = true
}