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
