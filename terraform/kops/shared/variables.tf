variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars

variable "allowed_cidr_blocks" {  # allowed-networks.tfvars
  type = list
}

variable "target_region" {
  default = "us-west-2"
}
