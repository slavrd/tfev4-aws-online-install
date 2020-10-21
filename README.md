# Terraform - TFEv4 EC2 Instance

A project to deploy TFEv4 and its external service in AWS, according to HashiCorp AWS reference [architecture](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/aws.html).

Terraform Enterprise will be installed using `online` installation [mode](https://www.terraform.io/docs/enterprise/install/installer.html#installation).

For the installation process to be automated the user needs to provide the files containing the SSL certificate which Terraform Enterprise will present, the certificate private key and the Terraform Enterprise licence. An AWS S3 bucket will be created and the files will be uploaded to it. During the installation process the files will be downloaded to the Terraform Enterprise EC2 instance from this S3 bucket.

The Terraform Enterprise version will be pinned to avoid unintentional upgrades when the EC2 instance is recreated. 

The Terraform configuration is divided into sub-modules. The root module in this directory is used to tie them together so that all resources can be provisioned with a single run e.g. for a demo.

The current Terraform configuration is supported by Terraform 0.13. For configuration compatible with Terraform 0.12 check out this repository's `tf-0.12`(https://github.com/slavrd/tfev4-aws-online-install/tree/tf-0.12) branch.

## Prerequisites

* Have Terraform `~> 0.13.0` [installed](https://www.terraform.io/downloads.html).
* Have AWS account with permissions as described [here](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/aws.html#additional-aws-resources).
* Have a valid SSL certificate and its private key for the hostname that will be used by Terraform Enterprise
* Have a valid Terraform Enterprise license file.

## Sub Modules

The resource configuration is split in the following modules placed in sub directories.

* `network` - network resources needed for the TFEv4 installation. A VPC, S3 access point for it and private and public subnets. Details on what the module does are in its [readme](./network/README.md).

* `ext-services` - external services needed for the TFEv4 installation. An PostgreSQL RDS instance and a S3 bucket. Details on what the module does are in its [readme](./ext-services/README.md).

* `asg-ec2-instance` - provisions an Auto Scaling group to deploy an EC2 instance with TFEv4 installed. Details on what the module does are in its [readme](./asg-ec2-instance/README.md).

* `installation-assets` - creates an S3 bucket and uploads the provided SSL certificate, its private key and TFE license files.

* `dns` - provisions a CNAME DNS record in AWS route53. Details on what the module does are in its [readme](./dns/README.md).

* `key-pair` - can create a key pair for the TFE EC2 instance. Can also be disabled in case an externally created key pair should be used. Details on what the module does are in its [readme](./key-pair/README.md).

* `ssh-hop` - will provision an EC2 instance with the latest Ubuntu Bionic OS in a public subnet to be used as an SSH hop to access the Terraform Enterprise instance. The module can be switched off using a Terraform input variable. Intended for use when building testing environments.

## Usage

This directory contains the Terraform code that ties the sub modules together. Each sub module can also be used individually by going to its sub directory.

### Requirements

* Terraform CLI version `~> 0.13.0`
* Terraform providers
  * `hashicorp/aws` version `~> 3.0`
  * `hashicorp/tls` version `~> 2.2` 

### Input Variables

Variables for the modules are placed in `variables.*.tf` files. Each variable has a description of what it us used for and many have default values provided as well.

The table below contains the input variables available for the root Terraform module. Any variables that do not have a `default` value must be set by the user.

The file `example.tfvars` is an example of a minimum set of input variables needed to successfully apply the Terraform configuration.

| Variable | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| common_tags | `map(string)` | `{}` | Common tags to assign to all resources. |
| name_prefix | `string` | `"tfe-"` | A string to be used as prefix for generating names of the created resources. |
| vpc_cidr_block | `string` | | CIDR for the VPC to create. |
| public_subnets_cidrs | `list(object({cidr=string, az_index=number}))` | | List of objects representing the public subnets CIDRs and their availability zones. The az_index property is used as an index to retrieve a zone from the list of the availability zones for the current AWS region. Check example.tfvars for example values. |
| private_subnets_cidrs | `list(object({cidr=string, az_index=number}))` | | List of objects representing the private subnets CIDRs and their availability zones. The az_index property is used as an index to retrieve a zone from the list of the availability zones for the current AWS region. Check example.tfvars for example values. |
| lb_internal | `bool` | `false` | Whether to create internal load balancer. |
| s3_bucket_name | `string` | | Name of the s3 bucket to create. |
| pg_instance_class | `string` | `"db.m4.large"` | The instance class of the PostgreSQL instance. |
| pg_engine_version | `string` | `"10.13"` | The engine version of the PostgreSQL instance. |
| pg_allocated_storage | `number` | `100` | Storage amount in GBs to allocate for the PostgreSQL instance. |
| pg_storage_type | `string` | `"gp2"` | Storage type used by the PostgreSQL instance. |
| pg_multi_az | `bool` | `false` | Specifies if the PostgreSQL instance is multi-AZ. |
| pg_parameter_group_name | `string` | `null` | Name of the DB parameter group to associate. |
| pg_deletion_protection | `bool` | `false` | If the PostgreSQL instance should have deletion protection enabled. |
| pg_backup_retention_period | `number` | `0` | The days to retain backups for. Must be between 0 and 35. |
| pg_db_name | `string` | `"tfe"` | The name of the database to create when the PostgreSQL instance is created. |
| pg_username | `string` | `"postgres"` | Username for the master PostgreSQL instance user. |
| pg_password | `string` | | Password for the master PostgreSQL instance user. |
| ami_id | `string` | | The AMI Id to use for the tfe instance. Must be Ubuntu 18.04 Bionic or 16.04 Xenial. |
| key_name | `string` | | Name of the AWS key pair to use for the tfe instance. |
| key_pair_create | `bool` | `false` | Wether to create an AWS key pair at all. If false the `key_name` variable must be set to an existing aws ec2 key pair. |
| public_key_path | `string` | `""` | Public key to use for the AWS key pair creation. If not provided a new TLS public/private key pair will be generated. |
| instance_type | `string` | `"m5a.large"` | The AWS instance type to use. |
| root_block_device_size | `number` | `50` | The size of the root block device volume in gigabytes. |
| health_check_type | `string` | `ELB` | Sets the health-check type for the auto scaling group. Accepted values ELB, EC2. |
| ingress_cidrs_http | `list(string)` | `["0.0.0.0/0"]` | CIDRs from which HTTP/HTTPS ingress traffic to the TFE instance is allowed. |
| ingress_cidrs_replicated_dashboard | `list(string)` | `["0.0.0.0/0"]` | "CIDRs from which ingress traffic to the TFE instance is allowed." |
| asg_lifecycle_hook_default_result | `string` | `ABANDON` | Sets the default action for the Auto Scaling group inital lifecycle hook. Can be ABANDON or CONTINUE. |
| replicated_password | `string` | | Password to set for the replicated console. |
| tfe_hostname | `string` | | Hostname which will be used to access the tfe instance. |
| tfe_enc_password | `string` | | Encryption password to be used by tfe. |
| tfe_release_sequence | `number` | | TFE version to install. Version must be pinned to avoid unintentional upgrades. The version is provided as the release sequence corresponding to the desired version e.g. `430` for version `v202005-2`. |
| tfe_certificate_path | `string` | | Path to the file containing the SSL certificate that TFE should present. |
| tfe_certificate_key_path | `string` | | Path to the file containing the private key for SSL certificate that TFE should present. |
| tfe_ca_bundle_path | `string` | `""` | Path to the file containing additional CA certificates that TFE should use. |
| tfe_associate_public_ip_address | `bool` | `false` | Wether to associate public ip address with the instance. Should be false except if bringing up standalone instance for testing. |
| create_ssh_hop | `bool` | `false` | Whether to create an EC2 instance and related resources to be used as a SSH hop. |
| ssh_ingress_cidrs | `list(string)` | `[]` | List of CIDRs from which incoming SSH connections are allowed. If the list is empty 0.0.0.0/0 will be used. Considered only if `create_ssh_hop` is set to `true`. |
| create_dns_record | `bool` | `true` | Weather to create a DNS record for the TFC hostame. If enabled the hostname must be in a zone hosted in AWS. |

### Outputs

The root module exposes the outputs described below

| Variable | Type | Description |
| -------- | ---- | ----------- |
| tfe_address | `string` | Address for accessing the tfe instance. |
| replicated_address | `string` | Address for accessing the replicate console. |
| private_key | `string` | The private key of the TLS key pair if such was created. |
| ssh_hop_public_ip | `string` | The public IP address of the SSH hop if such was created. |
| lb_dns | `string` | The DNS of the Network Load Balancer if front of the TFE instance. |

## Connect to ssh hop

In the event a ssh hop host is created, you can connect with the following steps

```
terraform output private_key > key.priv
chmod 0600 key.priv
ssh -i key.priv ubuntu@<ip>
```

If the AWS key pair was created with this Terraform configuration its private key will be copied to the ssh hop instance in `/home/ubuntu/.ssh/<key-pair-name>.pem`.

On the ssh hop instance an alias `tfeip` will be set up. It will use the AWS CLI to retrieve the IP of the Instances currently part of the TFE Auto Scaling group, provided via the `tfe_asg_name` input variable. Under normal circumstances this should be a single IP and so the following command can be used to connect to the TFE instance from the ssh hop.

```
ssh -i ~/.ssh/<key-pair-name>.pem ubuntu@`tfeip`
```

**caveats**

* The EC2 instance is set up via `cloud-init`. This means that completing the configuration will take some time, usually a couple of minutes, once the instance itself is up. Must allow enough time for the cloud-init configuration to complete before being able to use the ssh keys and the `tfeip` alias on the ssh hop.

### Provisioning with Terraform

- set the Terraform module input variables as described [here](https://www.terraform.io/docs/configuration/variables.html#assigning-values-to-root-module-variables).

- Set AWS credentials and region according to the Terraform AWS provider [documentation](https://www.terraform.io/docs/providers/aws/index.html).

- check and confirm the changes terraform will make to the infrastructure
  
  ```bash
  terraform plan
  ```
- provision the infrastructure

  ```bash
  terraform apply
  ```
### Updating Terraform Enterprise

The Terraform Enterprise version will be pinned to avoid unintentional upgrades when the EC2 instance is recreated. When the application needs to be updated ideally the following steps should be followed:

1. Set the `tfe_release_sequence` terraform variable to the release sequence corresponding to the new version.
2. Apply the terraform configuration. This will update the Auto Scaling group launch configuration but will not affect the current EC2 instance running Terraform Enterprise.
3. Terminate the current EC2 instance running Terraform Enterprise. This will make the Auto Scaling group launch a new EC2 instance using the updated launch configuration which will install the new TFE version.

If Terraform Enterprise is updated out of bounds e.g. via the Replicated Console UI make sure to perform steps 1 and 2. That way the Auto Scaling group launch configuration will also be updated and any new EC2 instances created by the Auto Scaling group will also install the new Terraform Enterprise version.
