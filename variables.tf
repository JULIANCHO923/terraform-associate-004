variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa, or prod."
  }
}

variable "common_tags" {
  type = map(string)
  default = {
    "ManagedBy" = "Terraform"
    "Project"   = "Hello-World-Compliance"
    "BussinesUnit" = "Personal"
  }
}

# Ephemeral variable for DB Password
ephemeral "variable" "db_password" {
  type      = string
  sensitive = true
}