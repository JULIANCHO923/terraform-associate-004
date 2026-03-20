locals {
  # Exam Tip: join() and upper() are common for naming conventions
  instance_prefix = join("-", [var.project_name, var.environment])
  
  # Sentinel Compliance Tags: Mandatory keys
  mandatory_tags = {
    Environment = upper(var.environment)
    Owner       = "PlatformTeam"
  }
}

# Data source to fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 Instances using for_each
resource "aws_instance" "app_servers" {
  for_each      = toset(["web-01", "web-02"])
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro" # Free Tier

  # merge() function combines tags. Sentinel checks these keys!
  tags = merge(
    var.common_tags,
    local.mandatory_tags,
    { Name = "${local.instance_prefix}-${each.key}" }
  )
}

# RDS Instance (Free Tier)
resource "aws_db_instance" "database" {
  allocated_storage   = 20
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro" # Free Tier
  db_name             = "helloworlddb"
  username            = "admin"
  
  # CERT TRAP: Standard resources usually require PERSISTENT passwords.
  # If you pass an ephemeral var to a persistent resource, TF will error.
  # For the exam, assume DB passwords are "Sensitive", not necessarily "Ephemeral" 
  # unless the resource is marked as "Write-only".
  password            = var.standard_sensitive_password 
  
  skip_final_snapshot = true
  
  tags = merge(var.common_tags, local.mandatory_tags)
}


# --- CAPA 1: VALIDATION (Input Level) ---
variable "instance_count" {
  type    = number
  default = 2
  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 5
    error_message = "Por costos, solo permitimos entre 1 y 5 instancias."
  }
}

# --- CAPA 2: PRECONDITION (Before Resource Action) ---
resource "aws_instance" "app" {
  count         = var.instance_count
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  lifecycle {
    precondition {
      # Validamos que la AMI no sea de un dueño desconocido antes de intentar crear
      condition     = data.aws_ami.amazon_linux.owner_id == "137112412989" # Amazon Owner ID
      error_message = "Seguridad: Solo se permiten AMIs oficiales de Amazon."
    }

    # --- CAPA 3: POSTCONDITION (After Resource Action) ---
    postcondition {
      # Verificamos que la instancia realmente haya quedado en la red correcta
      condition     = self.associate_public_ip_address == true
      error_message = "Error de red: La instancia se creó pero no tiene IP pública."
    }
  }
}

# --- CAPA 4: CHECKS (Continuous / Independent) ---
check "health_check" {
  data "http" "website" {
    url = "https://google.com" # Aquí iría la URL de tu App
  }

  assert {
    condition     = data.http.website.status_code == 200
    error_message = "¡Alerta! El sitio web no está respondiendo (Status: ${data.http.website.status_code})."
  }
}