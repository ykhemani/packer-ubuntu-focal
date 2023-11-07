source "azure-arm" "ubuntu-azure-us-east" {

  client_id       = vault("kv-v2/data/azure", "ARM_CLIENT_ID")
  client_secret   = vault("kv-v2/data/azure", "ARM_CLIENT_SECRET")
  subscription_id = vault("kv-v2/data/azure", "ARM_SUBSCRIPTION_ID")
  tenant_id       = vault("kv-v2/data/azure", "ARM_TENANT_ID")

  location = var.azure_region_us_east

  ssh_username = "packer"
  vm_size      = var.azure_vm_size

  os_type = "Linux"

  image_publisher = var.azure_base_image_publisher
  image_offer     = var.azure_base_image_offer
  image_sku       = var.azure_base_image_sku
  image_version   = var.azure_base_image_version

  managed_image_name                = "ubuntu-focal-yash-{{timestamp}}"
  managed_image_resource_group_name = "packer-resource-group"
  azure_tags                        = var.tags

  async_resourcegroup_delete = true

}

################################################################################
# Azure

variable "azure_vm_size" {
  type    = string
  default = "Standard_A1_v2"
}

variable "azure_base_image_publisher" {
  type    = string
  default = "Canonical"
}

variable "azure_base_image_offer" {
  type    = string
  default = "0001-com-ubuntu-server-focal"
}

variable "azure_base_image_sku" {
  type    = string
  default = "20_04-lts"
}

variable "azure_base_image_version" {
  type    = string
  default = "latest"
}

################################################################################
variable "azure_image_name" {
  type        = string
  description = "Value to use for naming Azure image."
  default     = "Ubuntu Focal (20.04) Golden Image"
}

variable "azure_region_us_east" {
  type        = string
  description = "Azure US East region."
  default     = "eastus"
}
