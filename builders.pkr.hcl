packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/amazon"
    }
    azure = {
      version = "1.2.0"
      source  = "github.com/hashicorp/azure"
    }
  }
}

locals {
  encrypted = var.encrypt_boot && var.aws_kms_key_id != "" ? "encrypted-" : ""
}

source "amazon-ebs" "ubuntu-us-east" {
  ami_name      = "${var.prefix}-${local.encrypted}{{timestamp}}"
  region        = var.aws_region_us_east
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

  tags = merge(
    var.tags,
    {
      Name = "${var.amazon_image_name} - ${var.owner} {{timestamp}}"
    }
  )
}

source "amazon-ebs" "ubuntu-us-west" {
  ami_name      = "${var.prefix}-${local.encrypted}{{timestamp}}"
  region        = var.aws_region_us_west
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

  tags = merge(
    var.tags,
    {
      Name = "${var.amazon_image_name} - ${var.owner} {{timestamp}}"
    }
  )
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
    "source.amazon-ebs.ubuntu-us-east",
    #"source.amazon-ebs.ubuntu-us-west",
    #"source.azure-arm.ubuntu-azure-us-east"
  ]

  provisioner "ansible" {
    playbook_file = "./playbook.yaml"
  }

  provisioner "shell" {
    inline = [
      "sudo curl -L \"https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl\" -o /usr/local/bin/kubectl",
      "sudo chmod +x /usr/local/bin/kubectl",
      "sudo curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64",
      "sudo chmod +x /usr/local/bin/kind",
      "sudo curl -Lo /tmp/go1.21.3.linux-amd64.tar.gz https://go.dev/dl/go1.21.3.linux-amd64.tar.gz",
      "sudo tar -C /usr/local -xzf /tmp/go1.21.3.linux-amd64.tar.gz",
      "export PATH=$PATH:/usr/local/go/bin",
      "echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/go.sh"
    ]
  }
}
