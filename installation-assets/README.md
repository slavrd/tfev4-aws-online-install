# TFEv4 External Services

A Terraform configuration to manage an S3 bucket used to hold the TFE installation assets.

## Description

The Terraform configuration provisions:

- S3 bucket. The bucket is not public and has no associated policies which restrict access.

- S3 bucket objects
  - SSL certificate to setup TFE with.
  - The private key to the SSL certificate
  - TFE license file.

**Caveat:** The S3 objects are created from local files. If these files change or are missing on subsequent runs, the TFE configuration will update the files or throw an error if they are missing. 

## Usage

For instructions on how to run Terraform configuration refer to the root module [readme](../README.md#Usage).

## Input Variables

The available input variables for the module are described in the table below.

| Variable | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| s3_bucket_name | `string` | | Name of the s3 bucket to create. |
| s3_bucket_region | `string` | | The AWS region in which to create the s3 bucket. |
| s3_force_delete | `bool` | `true` | Whether all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. |
| tfe_certificate_path | `string` | | Path to the local file containing the SSL certificate to upload to the S3 bucket. |
| tfe_certificate_key_path | `string` | | Path to the local file containing the SSL certificate private key to upload to the S3 bucket. |
| tfe_license_path | `string` | | Path to the local file containing the TFE license to upload to the S3 bucket. |
| create | `bool` | `true` | Whether to create the module resources. |
| common_tags | `map(string)` | `{}` | Tags to apply to all resources. |

## Outputs

The outputs defined for the module are described in the table below.

| Output | Type | Description |
| -------- | ---- | ----------- |
| tfe_cert | `string` | S3 path for the SSL certificate. |
| tfe_cert_key | `string` | S3 path for the SSL certificate private key. |
| tfe_ilcense | `string` | S3 path for the TFE license file. |
| s3_bucket_name | `string` | The name of the S3 bucket. Should be the same as what is specidiead in the input variable s3_bucket_name or empty string if creation was disabled. |