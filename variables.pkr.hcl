################################################################################
# AWS Specific
variable "aws_region_us_east" {
  type        = string
  description = "AWS Region in which to build image."
  default     = "us-east-1"
}

variable "aws_region_us_west" {
  type        = string
  description = "AWS Region in which to build image."
  default     = "us-west-2"
}

variable "aws_instance_type" {
  type        = string
  description = "Instance on which to build image."
  default     = "t2.micro"
}

variable "encrypt_boot" {
  type        = bool
  description = "Encrypt boot volume?"
  default     = false
}

variable "aws_kms_key_id" {
  type        = string
  description = "ARN for KMS Key ID to use for encrypting volume."
  default     = ""
}

variable "source_ami_filter_virtualization_type" {
  type        = string
  description = "Source AMI virtualization type filter."
  default     = "hvm"
}

variable "source_ami_filter_name" {
  type        = string
  description = "Source AMI name filter."
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  #default     = "CIS Amazon Linux 2 Benchmark v2* - Level 2*"
}

variable "source_ami_filter_rooot_device_type" {
  type        = string
  description = "Source AMI root device type"
  default     = "ebs"
}

variable "source_ami_owners" {
  type        = list(string)
  description = "Source AMI owner. Default is Canonical."
  default     = ["099720109477"]
}

variable "amazon_communicator" {
  type        = string
  description = "Communicator for Amazon builder."
  default     = "ssh"
}

variable "amazon_ssh_username" {
  type        = string
  description = "SSH username for Amazon builder."
  default     = "ubuntu"
  #default     = "ec2-user"
}

variable "amazon_image_name" {
  type        = string
  description = "Value to use for naming Amazon image."
  default     = "Ubuntu Focal (20.04) Golden Image"
}

################################################################################
variable "prefix" {
  type        = string
  description = "Prefix for naming image"
  default     = "ubuntu-focal-golden-image"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "owner" {
  type        = string
  description = "The person or group who launched these resources.  Must be a valid HashiCorp email prefix."
}

# variable "ttl" {
#   type        = string
#   description = "Time in hours from the launch that a resource can be stopped/terminated. Use -1 for permanent resources."
#   default     = "-1"
# }

# variable "config-as-code" {
#   type        = string
#   description = "Config-as-code tool used to provision this image."
#   default     = "packer"
# }

# variable "repo" {
#   type        = string
#   description = "If a config-as-code value is set, the repository that holds the code used to create this resource."
#   default     = ""
# }

################################################################################
# HCP Packer

variable "bucket_name" {
  type        = string
  description = "The image name when published to the HCP Packer registry. Will be overwritten if HCP_PACKER_BUCKET_NAME is set."
}

variable "bucket_description" {
  type        = string
  description = "The image description. Useful to provide a summary about the image. The description will appear at the image's main page and will be updated whenever it is changed and a new build is pushed to the HCP Packer registry. Should contain a maximum of 255 characters."
  default     = ""
}

