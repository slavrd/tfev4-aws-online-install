output "s3_bucket_name" {
  description = "The name of the bucket."
  value = aws_s3_bucket.tfe_s3_bucket.id
}

output "s3_bucket_region" {
  description = "The AWS region the bucket resides in."
  value = aws_s3_bucket.tfe_s3_bucket.region
}

output "pg_address" {
  description = "The hostname of the PostgreSQL instance."
  value       = aws_db_instance.tfe.address
}
