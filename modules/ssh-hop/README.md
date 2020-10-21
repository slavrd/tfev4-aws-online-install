# SSH Hop EC2 Instance

A simple Ubuntu bionic Ec2 instance intended to be used as an SSH hop.

The instance is built from the most recent Ubuntu Bionic image.

# Description

The Terraform configuration provisions:

  - An EC2 security group with rules allowing incoming SSH connections

  - A t2.micro EC2 instance

Instance OS level configurations 

  - The private SSH keys provided via the  `ssh_private_keys` input variable will be placed in `/home/ubuntu/.ssh` directory
  - The AWS CLI will be configured to use as default the region where the instance is placed.
  - An alias `tfeip` will be set up which will use the AWS CLI to retrieve the IP Address of the instances from the provided `tfe_asg_group`. Under normal circumstances should return a single IP Address.

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
| ssh_private_keys | `map(string)` | `{}` | A map of strings where the values contain private ssh keys to add to the Ubuntu user on the EC2 instance. File names are based on the map keys. |
| tfe_asg_group | `string` | `""` | The name of the AWS Auto Scaling group containing the instances for which the `tfeip` alias will retrieve IP Addresses. |

## Outputs 

The outputs declared by the module are described in the table bellow.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| public_ip | `string` | Public IP of the EC2 instance. |
| public_dns | `string` | Public DNS of the EC2 instance. |
