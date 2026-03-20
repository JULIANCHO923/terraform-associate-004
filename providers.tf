# Best Practice: Lock the provider version
terraform {
  required_version = "~> 1.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# EXAM TIP: Ephemeral variables only exist in memory during the run
ephemeral "variable" "aws_access_key" {
  type      = string
  sensitive = true
}

ephemeral "variable" "aws_secret_key" {
  type      = string
  sensitive = true
}

provider "aws" {
  region     = var.aws_region
  access_key = ephemeral.variable.aws_access_key
  secret_key = ephemeral.variable.aws_secret_key
}