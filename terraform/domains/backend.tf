terraform {
  required_version = ">= 0.12.20"
  backend "s3" {
    key = "domains/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}