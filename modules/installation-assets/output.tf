output "tfe_cert" {
  description = "S3 path for the SSL certificate."
  value       = try("s3://${aws_s3_bucket.tfe_installation_assets_s3_bucket[0].id}/${aws_s3_bucket_object.tfe_installation_assets["tfe_cert"].id}", "")
}

output "tfe_cert_key" {
  description = "S3 path for the SSL certificate private key."
  value       = try("s3://${aws_s3_bucket.tfe_installation_assets_s3_bucket[0].id}/${aws_s3_bucket_object.tfe_installation_assets["tfe_cert_key"].id}", "")
}

output "tfe_ilcense" {
  description = "S3 path for the SSL certificate."
  value       = try("s3://${aws_s3_bucket.tfe_installation_assets_s3_bucket[0].id}/${aws_s3_bucket_object.tfe_installation_assets["tfe_license"].id}", "")
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket. Should be the same as what is specidiead in the input variable s3_bucket_name or empty string if creation was disabled."
  value       = try(aws_s3_bucket.tfe_installation_assets_s3_bucket[0].id, "")
}