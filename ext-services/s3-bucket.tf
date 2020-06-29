resource "aws_s3_bucket" "tfe_s3_bucket" {
  bucket        = var.s3_bucket_name
  region        = var.s3_bucket_region
  acl           = "private"
  force_destroy = var.s3_force_delete

  tags = var.common_tags
}

resource "aws_s3_bucket_public_access_block" "tfe_s3_bucket" {
  bucket = aws_s3_bucket.tfe_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}