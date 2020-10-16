module "network" {
  #source                = "./network"
  source                = "git::https://github.com/slavrd/tfev4-aws-online-install//network"
  vpc_cidr_block        = var.vpc_cidr_block
  public_subnets_cidrs  = var.public_subnets_cidrs
  private_subnets_cidrs = var.private_subnets_cidrs
  name_prefix           = var.name_prefix
  lb_internal           = var.lb_internal
  common_tags           = var.common_tags
}

module "external_services" {
  #source                     = "./ext-services"
  source                     = "git::https://github.com/slavrd/tfev4-aws-online-install//ext-services"
  s3_bucket_name             = var.s3_bucket_name
  pg_vpc_id                  = module.network.vpc_id
  pg_subnet_ids              = module.network.private_subnets_ids
  pg_allow_ingress_cidrs     = var.private_subnets_cidrs[*].cidr
  pg_identifier_prefix       = var.name_prefix
  pg_instance_class          = var.pg_instance_class
  pg_engine_version          = var.pg_engine_version
  pg_allocated_storage       = var.pg_allocated_storage
  pg_storage_type            = var.pg_storage_type
  pg_multi_az                = var.pg_multi_az
  pg_parameter_group_name    = var.pg_parameter_group_name
  pg_deletion_protection     = var.pg_deletion_protection
  pg_backup_retention_period = var.pg_backup_retention_period
  pg_db_name                 = var.pg_db_name
  pg_username                = var.pg_username
  pg_password                = var.pg_password
  common_tags                = var.common_tags
}

module "key_pair" {
  #source          = "./key-pair"
  source          = "git::https://github.com/slavrd/tfev4-aws-online-install//key-pair"
  key_name        = var.key_name
  key_pair_create = var.key_pair_create
  public_key      = var.public_key_path == "" ? "" : file(var.public_key_path)
}

module "tfe_installation_assets" {
  #source                   = "./installation-assets"
  source                   = "git::https://github.com/slavrd/tfev4-aws-online-install//installation-assets"
  s3_bucket_name           = var.installation_assets_s3_bucket_name
  tfe_certificate_path     = var.tfe_certificate_path
  tfe_certificate_key_path = var.tfe_certificate_key_path
  tfe_license_path         = var.tfe_license_path
  common_tags              = var.common_tags
}

module "tfe_instance" {
  #source = "./asg-ec2-instance"
  source = "git::https://github.com/slavrd/tfev4-aws-online-install//asg-ec2-instance"
  vpc_id = module.network.vpc_id

  # If the tfe_associate_public_ip_address variable is set to false  (default) will place the auto scaling group in the privte subnets
  # If the tfe_associate_public_ip_address variable is set to true will place the auto scaling group in the public subnets
  # Should be done only for testing to make it easier to access the TFE instance.
  subnets_ids = var.tfe_associate_public_ip_address ? module.network.public_subnets_ids : module.network.private_subnets_ids

  # Since a Network Load balancer is used, the securtity group of the instance is used to control ingress traffic.
  # Need to add the CIDR of the public subnets to the input provided by the user mainly becaus the Load Balancer nodes are there.
  # The publicly available ports are still limited based on the NLB listeners - 80, 443, 8800.
  ingress_cidrs_http                 = concat(var.ingress_cidrs_http, var.public_subnets_cidrs[*].cidr, list("${module.network.nat_gateway_public_ip}/32"))
  ingress_cidrs_replicated_dashboard = concat(var.ingress_cidrs_replicated_dashboard, var.public_subnets_cidrs[*].cidr)

  # limit SSH ingress trafic to the public subnets CIDRs, where an SSH hop would be.
  ingress_cidrs_ssh = var.public_subnets_cidrs[*].cidr

  ami_id                             = var.ami_id
  key_name                           = var.key_pair_create ? module.key_pair.key_pair_name : var.key_name
  instance_type                      = var.instance_type
  name_prefix                        = var.name_prefix
  target_groups_arns                 = [module.network.lb_tg_80_arn, module.network.lb_tg_443_arn, module.network.lb_tg_8800_arn]
  associate_public_ip_address        = var.tfe_associate_public_ip_address
  root_block_device_size             = var.root_block_device_size
  health_check_type                  = var.health_check_type
  asg_lifecycle_hook_default_result  = var.asg_lifecycle_hook_default_result
  replicated_password                = var.replicated_password
  tfe_hostname                       = var.tfe_hostname
  tfe_enc_password                   = var.tfe_enc_password
  tfe_release_sequence               = var.tfe_release_sequence
  installation_assets_s3_bucket_name = module.tfe_installation_assets.s3_bucket_name
  tfe_license_s3_path                = module.tfe_installation_assets.tfe_ilcense
  tfe_cert_s3_path                   = module.tfe_installation_assets.tfe_cert
  tfe_privkey_s3_path                = module.tfe_installation_assets.tfe_cert_key
  tfe_ca_bundle                      = var.tfe_ca_bundle_path == "" ? "" : replace(chomp(file(var.tfe_ca_bundle_path)), "/\r{0,1}\n/", "\\n")
  tfe_pg_dbname                      = var.pg_db_name
  tfe_pg_address                     = module.external_services.pg_address
  tfe_pg_password                    = var.pg_password
  tfe_pg_user                        = var.pg_username
  tfe_s3_bucket                      = module.external_services.s3_bucket_name
  tfe_s3_region                      = var.aws_region
  common_tags                        = var.common_tags
}

locals {
  tfe_hostname_split = split(".", var.tfe_hostname)
}

module "tfe_dns" {
  count            = var.create_dns_record ? 1 : 0
  #source           = "./dns"
  source           = "git::https://github.com/slavrd/tfev4-aws-online-install//dns"
  cname_value      = module.network.lb_dns_name
  cname_record     = element(local.tfe_hostname_split, 0)
  hosted_zone_name = join(".", slice(local.tfe_hostname_split, 1, length(local.tfe_hostname_split)))
}

module "ssh_hop" {
  #source              = "./ssh-hop"
  source              = "git::https://github.com/slavrd/tfev4-aws-online-install//ssh-hop"
  enable              = var.create_ssh_hop
  name_prefix         = var.name_prefix
  subnet_id           = module.network.public_subnets_ids[0]
  vpc_id              = module.network.vpc_id
  allow_ingress_cirds = var.ssh_ingress_cidrs
  key_name            = var.key_name
  common_tags         = var.common_tags
}
