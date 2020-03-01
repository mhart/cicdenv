variable "region" {}
variable "bucket" {}

variable "name" {
  description = "Unique Jenkins instance name."

  type = string
}

variable "instance_type" {
  description = "AWS EC2 instance type.  Supported: c5d.*, m5d*.*, r5d*.*, z1d.*, i3*"

  type = string
}

variable "executors" {
  description = "Conccurrent build job slots."

  type = number
}