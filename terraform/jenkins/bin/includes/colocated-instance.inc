#!/bin/bash

cat <<'EOF' > "instances/${name}/locals.tf"
locals {
  ami_id = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_amis["ext4-zfs"].id
}
EOF

cat <<EOF >> "instances/${name}/variables.tf"

variable "instance_type" {
  default = "${tf_vars[instance_type]}"
}
variable "executors" {
  default = ${tf_vars[executors]}
}
EOF

cat <<EOF > "instances/${name}/jenkins.tf"
module "jenkins_instance" {
  source = "../../modules/service/colocated"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
  
  ami_id = local.ami_id
  
  name = "${name}"

  instance_type = var.instance_type

  executors = var.executors
}
EOF

cat <<EOF > "instances/${name}/outputs.tf"
output "type" {
  value = "${type}"
}

output "autoscaling_groups" {
  value = module.jenkins_instance.autoscaling_groups
}

output "ami" {
  value = {
    id = local.ami_id
  }
}

output "url" {
  value = "https://\${module.jenkins_instance.dns.external_name}"
}
EOF
