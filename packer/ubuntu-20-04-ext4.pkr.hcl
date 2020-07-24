variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_id" {
  type = string
}

variable "account_ids" {
  type = list(string)
}

source "amazon-ebs" "builder" {
  region    = "us-west-2"
  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id
  
  source_ami_filter {
    filters = {
      name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"

      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }

  instance_type = "c5.large"
  
  associate_public_ip_address = true

  ssh_username  = "ubuntu"
  ssh_interface = "public_ip"
  ssh_timeout   = "2m"

  ami_name        = "base/ubuntu-20.04-amd64-ext4-{{ isotime | clean_resource_name }}"
  ami_description = "https://github.com/vogtech/cicdenv/terraform/packer/ubuntu-20.04-ext4.pkr.hcl"
  snapshot_users  = var.account_ids
  ami_users       = var.account_ids

  ami_block_device_mappings {
    device_name = "/dev/sda1"
    volume_type = "io1"
    volume_size = 50
    
    iops = 2500
    
    delete_on_termination = true
  }

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_type = "io1"
    volume_size = 50

    iops = 2500

    delete_on_termination = true
  }

  iam_instance_profile = "packer-build"
}

build {
  sources = [
    "source.amazon-ebs.builder"
  ]
  
  provisioner "ansible" {
    playbook_file = "./ansible/playbook-ext4.yml"
    
    ansible_env_vars = [
      "ANSIBLE_SSH_ARGS='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o AddKeysToAgent=no -o IdentitiesOnly=yes'",
    ]
  }

  provisioner "file" {
    source      = "./scripts/info.sh"
    destination = "/tmp/info.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo chmod +x /tmp/info.sh",
      "sudo /tmp/info.sh > /tmp/info.txt"
    ]
  }

  provisioner "file" {
    source      = "/tmp/info.txt"
    destination = "./ami-info/ubuntu-20.04-ext4-{{ isotime \"2006-01-02T15-04-05Z07\" }}.txt"
    direction   = "download"
  }
}