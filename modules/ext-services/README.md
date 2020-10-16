# TFEv4 External Services

A Terraform configuration to build the external services needed for a TFEv4 install.

## Description

The Terraform configuration provisions:

- S3 bucket. The bucket is not public and has no associated policies which restrict access.

- AWS Security group used for the RDS instance. The security group will allow all ingress traffic to port `5432`.

- EC2 instance based on the specific AMI. The user data will be set to:
  
- DB Subnet groups to be used by the RDS instance.

- PostgreSQL RDS instance. The instance has public access and storage scaling disabled and is set to skip creating a final snapshot on deletion. Other parameters are customizable via the module input variables in `variables.pg.tf`. Most of them have sane defaults for a demo setup.

## Usage

For instructions on how to run Terraform configuration refer to the root module [readme](../README.md#Usage).
