aws_region     = "eu-central-1"
vpc_cidr_block = "172.30.16.0/20"

# Type is required by the used network module.
# For each subnet it is needed to provide a CIDR and AZ in which to place it. 
# The AZ is provided as a number. This number is used as index to select an AZ from the list of AZs for the current AWS region.

public_subnets_cidrs = [
  {
    cidr     = "172.30.16.0/24"
    az_index = 0
  },
  {
    cidr     = "172.30.17.0/24"
    az_index = 1
  },
]

private_subnets_cidrs = [
  {
    cidr     = "172.30.24.0/24"
    az_index = 0
  },
  {
    cidr     = "172.30.25.0/24"
    az_index = 1
  },
]

name_prefix = "my-tfe-"

ami_id          = "base-ubuntu-bionic-ami-id"
key_name        = "my-key-pair"
key_pair_create = true

installation_assets_s3_bucket_name = "my-tfe-installation-assets"
tfe_license_path                   = "/path/to/my-tfe-license.rli"
tfe_certificate_path               = "/path/to/tfe-cert.pem"
tfe_certificate_key_path           = "/path/to/tfe-cert-privkey.pem"

s3_bucket_name = "my-tfe"
pg_multi_az    = true
pg_password    = "Password123#"

tfe_hostname         = "tfe.domain.com"
tfe_release_sequence = 479
replicated_password  = "Password123#"
tfe_enc_password     = "Password123#"

create_ssh_hop = false

# can be a map(string) containing any key/value pairs. The key values below are just examples.
common_tags = {
  owner   = "owner@domain.com"
  project = "terraform-tfe"
}
