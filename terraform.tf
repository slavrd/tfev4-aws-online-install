terraform {
  required_version = "~> 0.12.20"
  required_providers {
    aws = "~> 2.49"
  }
}

provider "aws" {
  region = var.aws_region
}