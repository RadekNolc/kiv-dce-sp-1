variable "provider_endpoint" {
  description = "Open Nebula endpoint URL"
}

variable "provider_username" {
  description = "Open Nebula username"
}

variable "provider_password" {
  description = "Open Nebula password"
}

variable "vm_admin_user" {
  description = "Administrator user for VMs"
  default = "sysadmin"
}

variable "vm_image_name" {
  description = "Name of the VM image"
}

variable "vm_image_url" {
  description = "URL of the VM image"
}

variable "vm_backend_count" {
  description = "Number of VM backend instances to create"
  default     = 2
}

variable "vm_ssh_privkey_path" {
  description = "SSH private key path in local environment"
}

variable "vm_ssh_pubkey" {
  description = "SSH public key to inject into the VM"
}