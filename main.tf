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
      version = "~> 5.0" # Allows 5.x, but not 6.0
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

provider "aws" {
  alias      = "west"
  region     = "us-west-2"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_s3_bucket" "east_bucket" {
  bucket = "odisea-study-bucket-9e4055d3"
  # Uses default provider automatically

  tags = {
    BusinessUnit = "local"
  }
}

resource "aws_s3_bucket" "west_bucket" {
  provider = aws.west # Explicitly uses the alias
  bucket   = "odisea-west-${random_id.id.hex}"

  tags = {
    BusinessUnit = "local"
  }
}

resource "random_id" "id" {
  byte_length = 4
}


moved {
  from = random_id.suffix
  to   = random_id.id
}


moved {
  from = aws_s3_bucket.practice_bucket
  to   = aws_s3_bucket.east_bucket
}