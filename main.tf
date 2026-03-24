# The "Cloud" block tells Terraform to store your state in HCP 
terraform {
  cloud {
    organization = "hello-world-tf-exam-004"

    workspaces {
      name = "terraform-associate-004"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

variable "AWS_ACCESS_KEY_ID" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}


# Credentials: set HCP Environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
provider "aws" {
  region     = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_s3_bucket" "practice_bucket" {
  # S3 bucket names must be globally unique
  bucket = "odisea-study-bucket-${random_id.suffix.hex}"
  tags = {
    BusinessUnit = "local"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}