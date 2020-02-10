data "terraform_remote_state" "apt_repo" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared-apt-repo/terraform.tfstate"
    region = var.region
  }
}
