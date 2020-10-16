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
  description = "Encryption password to be used by TFE."
}

variable "tfe_release_sequence" {
  type        = number
  description = "The realese sequence corresponding to the TFE version which should be installed."
}

variable "installation_assets_s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket containing the installation assets - ssl certificate, ssl certificate key and tfe license."
}

variable "tfe_license_s3_path" {
  type        = string
  description = "S3 Path to the TFE license .rli file."
}

variable "tfe_cert_s3_path" {
  type        = string
  description = "S3 Path to the file containing the certificate chain which should be presented by the TFE."
}

variable "tfe_privkey_s3_path" {
  type        = string
  description = "S3 Path to the file containing the private key for the certificate which should be presented by the TFE."
}

variable "tfe_ca_bundle" {
  type        = string
  description = "The additionla CA certificates to add to TFE. Value needs to be a string with new line characters replaced with literal \n."
  default     = ""
}

variable "tfe_pg_dbname" {
  type        = string
  description = "Name of the PostGRE data base to be used by TFE."
}

variable "tfe_pg_address" {
  type        = string
  description = "Address of the PostGRE data base to be used by TFE. Must contian hostname and optionally a port."
}

variable "tfe_pg_password" {
  type        = string
  description = "Password tfe will use to access the PostGRE data base."
}

variable "tfe_pg_user" {
  type        = string
  description = "Username tfe will use to access the PostGRE data base."
}

variable "tfe_s3_bucket" {
  type        = string
  description = "Name of the S3 bucket tfe will use for object storage."
}

variable "tfe_s3_region" {
  type        = string
  description = "AWS region of the S3 bucket tfe will use for object storage."
}
