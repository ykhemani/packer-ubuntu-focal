packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  encrypted = var.encrypt_boot && var.aws_kms_key_id != "" ? "encrypted-" : ""
}

source "amazon-ebs" "ubuntu-east" {
  ami_name      = "${var.prefix}-${local.encrypted}{{timestamp}}"
  region        = var.aws_region
  instance_type = var.aws_instance_type
  encrypt_boot  = var.encrypt_boot
  kms_key_id    = var.encrypt_boot ? var.aws_kms_key_id : ""

  source_ami_filter {
    filters = {
      virtualization-type = var.source_ami_filter_virtualization_type
      name                = var.source_ami_filter_name
      root-device-type    = var.source_ami_filter_rooot_device_type
    }
    owners      = var.source_ami_owners
    most_recent = true
  }
  communicator = var.amazon_communicator
  ssh_username = var.amazon_ssh_username

  tags = {
    Name           = "${var.amazon_image_name} - ${var.owner} {{timestamp}}"
    owner          = var.owner
    ttl            = var.ttl
    config-as-code = var.config-as-code
    repo           = var.repo
  }
}

build {
  hcp_packer_registry {
    bucket_name = var.bucket_name
    description = var.bucket_description

    bucket_labels = {
      "os" = "linux"
    }

    build_labels = {
      "build-time" = timestamp()
    }
  }

  sources = [
    "source.amazon-ebs.ubuntu-east"
  ]

  ## via shell provisioner
  #  provisioner "shell" {
  #    execute_command = "{{.Vars}} bash '{{.Path}}'"
  #    inline = [
  #      "sudo yum update -y",
  #      "sudo yum install -y yum-utils",
  #      "sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo",
  #      "sudo yum -y install terraform vault-enterprise consul-enterprise nomad-enterprise packer consul-template"
  #    ]
  #  }

  provisioner "ansible" {
    playbook_file = "./playbook.yaml"
  }
}

