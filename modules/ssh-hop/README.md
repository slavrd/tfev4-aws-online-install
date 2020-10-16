# SSH Hop EC2 Instance

A simple Ubuntu bionic Ec2 instance intended to be used as an SSH hop.

The instance is built from the most recent Ubuntu Bionic image.

# Description

The Terraform configuration provisions:

- An EC2 security group with rules allowing incoming SSH connections

- A t2.micro EC2 instance

## Usage

For instructions on how to run Terraform configuration refer to the root module [readme](../README.md#Usage).

## Input Variables

The available input variables for the module are described in the table below.

| Variable | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| enable | `bool` | `true` | Whether to create the module resources. |
| subnet_id | `string` | | The Id of the subnet in which to place the EC2 instance. |
| vpc_id | `string` | | The Id of the VPC in which the subnet is placed. |
| allow_ingress_cirds | `list(string)` | `[]` | List of CIDRs from which incoming traffic SSH connections are allowed. If the list is empty 0.0.0.0/0 will be used. |
| key_name | `string` | | Name of the AWS key pair to use for the EC2 instance. |
| common_tags | `map(string)` | `{}` | Common tags to assign to all resources. |
| name_prefix | `string` | `"tfe-"` | A string to be used as prefix for generating names of the created resources. |



