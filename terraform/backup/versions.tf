terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66"
    }
  }

  backend "s3" {
    key = "terraform.diy-pcp-backup.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}
