# TFEv4 key pair

A Terraform module to manage an AWS key pair.

The module can create an AWS key pair based on a provided public key or it can generate a new public/private ssh key pair. In case of the latter the private key will be stored in the terraform state file and assigned to a module output un-encrypted.

Based on the provided input variables the module can create no resources at all. This is to get around the current limitation of Terraform modules not supporting the count attribute.

## Description

The Terraform configuration provisions:

- AWS key pair.

- TLS public/private key pair (optional).

## Usage

For instructions on how to run Terraform configuration refer to the root module [readme](../README.md#Usage).
