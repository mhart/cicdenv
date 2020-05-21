terraform {
  required_version = ">= 0.12.15"
  backend "s3" {
    key = "state/main/shared_ecr-images_bastion-sshd-worker/terraform.tfstate"
  }
}
