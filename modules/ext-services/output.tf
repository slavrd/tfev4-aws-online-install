output "s3_bucket_name" {
  value = aws_s3_bucket.tfe_s3_bucket.id
}

output "pg_address" {
  description = "The hostname of the PostgreSQL instance."
  value       = aws_db_instance.tfe.address
}
