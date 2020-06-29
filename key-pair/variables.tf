variable "key_name" {
  type        = string
  description = "Name of the AWS key pair to be created."
}

variable "key_pair_create" {
  type        = bool
  description = "Wether to create an AWS key pair at all."
  default     = true
}

variable "public_key" {
  type        = string
  description = "Public key to use for the AWS key pair createion. If not provided a new TLS public/private key pair will be generated."
  default     = ""
}
