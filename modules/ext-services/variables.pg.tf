variable "pg_identifier_prefix" {
  type        = string
  description = "Prefix to use for the PostgreSQL instance identifier."
  default     = "tfe-pg-instance-"
}

variable "pg_subnet_ids" {
  type        = list(string)
  description = "List of AWS subent ids to use for PostgreSQL DB subnet group."
}

variable "pg_vpc_id" {
  type        = string
  description = "Id of the VPC in which the PostgreSQL instance is being created. Used to create the security group."
}

variable "pg_allow_ingress_cidrs" {
  type        = list(string)
  description = "CIDR to allow ingress traffic from."
}

variable "pg_instance_class" {
  type        = string
  description = "The instance class of the PostgreSQL instance."
  default     = "db.m4.large"
}

variable "pg_engine_version" {
  type        = string
  description = "The engine versoin of the PostgreSQL instance."
  default     = "10.13"
}

variable "pg_allocated_storage" {
  type        = number
  description = "Storage ammount to allocate for the PostgreSQL instance."
  default     = 100
}

variable "pg_storage_type" {
  type        = string
  description = "Storage type used by the PostgreSQL instance."
  default     = "gp2"
}

variable "pg_multi_az" {
  type        = bool
  description = "Specifies if the PostgreSQL instance is multi-AZ."
  default     = false
}

variable "pg_parameter_group_name" {
  type        = string
  description = "Name of the DB parameter group to associate"
  default     = null
}

variable "pg_deletion_protection" {
  type        = bool
  description = "If the PostgreSQL instance should have deletion protection enabled."
  default     = false
}

variable "pg_backup_retention_period" {
  type        = number
  description = "The days to retain backups for. Must be between 0 and 35."
  default     = 0
}

variable "pg_db_name" {
  type        = string
  description = "The name of the database to create when the PostgreSQL instance is created."
  default     = "tfe"
}

variable "pg_username" {
  type        = string
  description = "Username for the master PostgreSQL instance user."
  default     = "postgres"
}

variable "pg_password" {
  type        = string
  description = "Password for the master PostgreSQL instance user."
}