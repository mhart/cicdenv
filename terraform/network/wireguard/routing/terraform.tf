terraform {
  required_version = ">= 0.12.29"
  backend "s3" {
    key = "state/main/network_wireguard_routing/terraform.tfstate"
  }
}
