# Definimos las variables necesarias para el proveedor durante el test
variables {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

# PRUEBA 1: Validación del Plan (Unit Test)
# Verificamos la lógica de nombres y tags sin crear nada en AWS todavía.
run "verify_bucket_logic" {
  command = plan

  assert {
    condition     = aws_s3_bucket.east_bucket.tags["BusinessUnit"] == "local"
    error_message = "El bucket de East no tiene el tag BusinessUnit correcto."
  }

  assert {
    condition     = random_id.id.byte_length == 4
    error_message = "El ID aleatorio debe tener una longitud de 4 bytes."
  }
}