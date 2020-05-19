terraform {
  required_version = ">= 0.12.24"
  backend "s3" {
    key = "state/main/shared-ecr-images-bastion-events-worker/terraform.tfstate"
  }
}