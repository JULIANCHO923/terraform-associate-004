# The "Cloud" block tells Terraform to store your state in HCP 
terraform {
  cloud {
    organization = "hello-world-tf-exam-004"

    workspaces {
      name = "terraform-associate-004"
    }
  }
  required_version = "1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Allows 5.x, but not 6.x 
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


# 1. Obtener la AMI más reciente de Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# 2. Definición de la Instancia
resource "aws_instance" "app_server_large" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.2xlarge" # 8 vCPUs, 32 GiB RAM

  # Configuración de almacenamiento (Best Practice para instancias grandes)
  root_block_device {
    volume_size           = 50
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true
  }

  # Tags de cumplimiento (Para que Sentinel no nos bloquee)
  tags = {
    Name         = "prod-app-server-01"
    Environment  = "production"
    BusinessUnit = "Engineering" # Tag obligatorio según nuestro ejercicio previo
    ManagedBy    = "Terraform"
  }

  # Evitar que cambios accidentales en tags recrean la instancia
  lifecycle {
    ignore_changes = [tags["BusinessUnit"]]
  }
}