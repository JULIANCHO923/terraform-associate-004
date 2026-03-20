# 🚀 Terraform Associate 004: Lab de Infraestructura Segura

Este repositorio contiene un proyecto "Hello World" evolucionado para AWS, diseñado para cubrir los objetivos clave del examen de certificación **HashiCorp Certified: Terraform Associate (004)**.

---

## 🧠 Conceptos Core del Examen en este Proyecto

### 1. Gestión de Secretos y Variables Efímeras (v1.12+)
Para evitar que las credenciales queden grabadas en el archivo `terraform.tfstate`, utilizamos:
* **`ephemeral "variable"`**: Valores que solo viven en memoria.
* **Uso:** Autenticación del Provider y contraseñas de Base de Datos.
* **Tip de Examen:** Los datos efímeros NO aparecen en el JSON del estado.

### 2. El Ciclo de Vida de las Validaciones
Implementamos las 4 capas de validación de Terraform:

| Tipo | Momento de Ejecución | ¿Bloquea el Apply? | Propósito |
| :--- | :--- | :--- | :--- |
| **Variable Validation** | Inicio del Plan | Sí | Validar formato del input (ej. Regex de nombres). |
| **Precondition** | Antes de crear el recurso | Sí | Validar dependencias externas (ej. ¿Existe la AMI?). |
| **Postcondition** | Después de crear el recurso | Sí | Validar el resultado (ej. ¿Tiene IP pública?). |
| **Check** | Continuo / Al final | No (Warning) | Monitoreo de salud (ej. ¿Responde el endpoint?). |

---

## 🛠 Comandos Críticos de Gestión de Estado (`tfstate`)

En este laboratorio practicamos la manipulación segura del estado:
* `terraform state list`: Muestra qué recursos "recuerda" Terraform.
* `terraform state show <recurso>`: Atributos detallados de un objeto en el estado.
* `terraform plan -refresh-only`: Sincroniza el estado con la realidad de AWS sin cambiar nada.
* `terraform state mv`: Renombrar recursos en el estado (usar bloque `moved` en código es preferible).

---

## 🏷 Estrategia de Tags y Cumplimiento (Sentinel)
Para alinearnos con las políticas de **HCP Sentinel (Policy as Code)**, usamos la función `merge()` en `locals.tf`.

```hcl
# Ejemplo de lógica de tags obligatorios
tags = merge(var.common_tags, {
  Environment = upper(var.environment)
  Project     = "Odisea-Viajera-Study"
})