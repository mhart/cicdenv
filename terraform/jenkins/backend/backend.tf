terraform {
  required_version = ">= 0.12.20"
  backend "s3" {
    key = "state/main/jenkins_backend/terraform.tfstate"
  }
}
