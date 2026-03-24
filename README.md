# 🚀 Terraform Associate 004: Lab 1 - The "Hello World" of IaC



## Pre-commit

https://github.com/antonbabenko/pre-commit-terraform/blob/master/README.md

brew install pre-commit terraform-docs tflint tfsec trivy checkov terrascan infracost tfupdate minamijoyo/hcledit/hcledit jq

# Terraform docs

`terraform-docs markdown table --output-file README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_aws.west"></a> [aws.west](#provider\_aws.west) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.east_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.west_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_AWS_ACCESS_KEY_ID"></a> [AWS\_ACCESS\_KEY\_ID](#input\_AWS\_ACCESS\_KEY\_ID) | n/a | `string` | n/a | yes |
| <a name="input_AWS_SECRET_ACCESS_KEY"></a> [AWS\_SECRET\_ACCESS\_KEY](#input\_AWS\_SECRET\_ACCESS\_KEY) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->