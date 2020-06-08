variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
variable "domain" {} # domain.tfvars

variable "whitelisted_cidr_blocks" {  # whitelisted-networks.tfvars
  type = list
}

variable "github_hooks_cidr_blocks" {  # whitelisted-networks.tfvars
  type = list
}

variable "target_region" {
  default = "us-west-2"
}
