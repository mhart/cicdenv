data "terraform_remote_state" "ecr_jenkins" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared-ecr-images-jenkins/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/domains/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "jenkins_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/jenkins-backend/terraform.tfstate"
    region = var.region
  }
}