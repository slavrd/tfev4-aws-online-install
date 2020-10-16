resource "aws_security_group" "tfe-pg" {
  name        = "tfe-pg"
  description = "Allow incoming traffic for tfe Postgre SQL instance."
  vpc_id      = var.pg_vpc_id
  tags        = var.common_tags
}

resource "aws_security_group_rule" "allow_pg_default" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.pg_allow_ingress_cidrs
  security_group_id = aws_security_group.tfe-pg.id
}

resource "aws_db_subnet_group" "tfe-pg" {
  name_prefix = "tfe-"
  subnet_ids  = var.pg_subnet_ids
  description = "A subnet group for the tfe PostgreSQL RDS instance."
  tags        = var.common_tags
}

resource "aws_db_instance" "tfe" {
  identifier_prefix       = var.pg_identifier_prefix
  allocated_storage       = var.pg_allocated_storage
  storage_type            = var.pg_storage_type
  max_allocated_storage   = 0
  engine                  = "postgres"
  engine_version          = var.pg_engine_version
  instance_class          = var.pg_instance_class
  name                    = var.pg_db_name
  username                = var.pg_username
  password                = var.pg_password
  parameter_group_name    = var.pg_parameter_group_name
  vpc_security_group_ids  = [aws_security_group.tfe-pg.id]
  db_subnet_group_name    = aws_db_subnet_group.tfe-pg.name
  multi_az                = var.pg_multi_az
  publicly_accessible     = false
  deletion_protection     = var.pg_deletion_protection
  backup_retention_period = var.pg_backup_retention_period
  skip_final_snapshot     = true
  tags                    = var.common_tags
}

