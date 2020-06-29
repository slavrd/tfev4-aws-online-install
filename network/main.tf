module "tfe-network" {

  source = "github.com/slavrd/terraform-aws-basic-network?ref=0.3.0"

  vpc_cidr_block       = var.vpc_cidr_block
  name_prefix          = trimsuffix(var.name_prefix, "-") # Avoids double "-". The module adds suffix starting with "-" to the names.
  common_tags          = var.common_tags
  public_subnet_cidrs  = var.public_subnets_cidrs
  private_subnet_cidrs = var.private_subnets_cidrs

}

data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.tfe-network.vpc_id
  service_name = data.aws_vpc_endpoint_service.s3.service_name
  tags         = var.common_tags
}

resource "aws_vpc_endpoint_route_table_association" "public_rt" {
  route_table_id  = module.tfe-network.public_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "main_rt" {
  route_table_id  = module.tfe-network.main_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
