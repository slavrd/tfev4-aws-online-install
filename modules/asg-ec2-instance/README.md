# TFEv4 Auto Scaling Group - EC2 Instance

A Terraform configuration to build an Auto Scaling Group which brings up EC2 instance with TFEv4 installed. The TFE installation will be in external services mode using AWS S3 and AWS PostgreSQL RDS.

## Description

The Terraform configuration provisions:

- An AWS role which allows the created EC2 instance full access to S3 resources

- Security group which allows network traffic from the EC2 instance according to the TFE [documentation](https://www.terraform.io/docs/enterprise/before-installing/network-requirements.html).

- Auto Scaling Group which will bring up a single EC2 instance and register it in provided target groups.

- Launch Configuration for the EC2 instance which is based on the specific AMI. The user data will be set to:
  
  - create an `/ect/replicated.conf` file based on the input variables.
  - create an `/opt/tfe-installer/settings.conf` file based on the input variables.
  - Run the replicated installation script according to the TFE [documentation](https://www.terraform.io/docs/enterprise/install/automating-the-installer.html) using the created settings files.

## Usage

For instructions on how to run Terraform configuration refer to the root module [readme](../README.md#Usage).
