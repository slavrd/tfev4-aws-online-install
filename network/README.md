# TFEv4 network

A Terraform module to manage AWS networks resources needed to install TFEv4.

It uses this [module](https://github.com/slavrd/terraform-aws-basic-network) to manage most of the resources.

## Description

The Terraform configuration provisions:

- VPC

- Public subnets, accessible from the Internet.

- Private subnets which are not accessible from the Internet. Outgoing connections from the private subnets to the Internet are still possible. 

    **note:** All subnets can be places in the same or different AZs based on the provided input variables. Refer to the variables descriptions in the `varibles.tf` file for more details.
  
- Internet gateway to allow Internet access from / to the VPC.

- NAT gateway to allow outgoing only access to the Internet from the private subnets.

- The necessary route tables and route table associations.

- S3 access point for the VPC so that all traffic between resources in the VPC and the S3 service is internal. Access point allows traffic to any S3 resource.

- Network load balancer. The load balancer will forward TCP traffic on ports 80,443 and 8800.

## Usage

For instructions on how to run Terraform configuration refer to the root module [readme](../README.md#Usage).
