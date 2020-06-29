resource "aws_s3_bucket" "tfe_installation_assets_s3_bucket" {
  count         = var.create ? 1 : 0
  bucket        = var.s3_bucket_name
  region        = var.s3_bucket_region
  acl           = "private"
  force_destroy = var.s3_force_delete

  tags = var.common_tags
}

resource "aws_s3_bucket_public_access_block" "tfe_installation_assets_s3_bucket" {
  count  = var.create ? 1 : 0
  bucket = aws_s3_bucket.tfe_installation_assets_s3_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  tfe_assets = {
    tfe_cert = {
      local_path    = var.tfe_certificate_path
      s3_object_key = "cert.pem"
    }
    tfe_cert_key = {
      local_path    = var.tfe_certificate_key_path
      s3_object_key = "privkey.pem"
    }
    tfe_license = {
      local_path    = var.tfe_license_path
      s3_object_key = "tfe-license.rli"
    }
  }
}

resource "aws_s3_bucket_object" "tfe_installation_assets" {
  for_each = var.create ? local.tfe_assets : {}
  bucket   = aws_s3_bucket.tfe_installation_assets_s3_bucket[0].id
  key      = each.value.s3_object_key
  source   = each.value.local_path
  etag     = filemd5(each.value.local_path)
}