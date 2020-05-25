data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = var.terraform_settings.bucket
    key    = "state/main/kops_backend/terraform.tfstate"
    region = var.terraform_settings.region
  }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_settings.bucket
    key    = "state/${terraform.workspace}/kops_shared/terraform.tfstate"
    region = var.terraform_settings.region
  }
}

data "terraform_remote_state" "iam_users" {
  backend = "s3"
  config = {
    bucket = var.terraform_settings.bucket
    key    = "state/main/iam_users/terraform.tfstate"
    region = var.terraform_settings.region
  }
}