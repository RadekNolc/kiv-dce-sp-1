
terraform {
  required_providers {
    opennebula = {
      source = "OpenNebula/opennebula"
      version = "0.4.3"
    }
  }
}

provider "opennebula" {
  endpoint      = var.provider_endpoint
  username      = var.provider_username
  password      = var.provider_password
}

resource "opennebula_image" "os-image" {
  name = var.vm_image_name
  datastore_id = 101
  persistent = false
  path = var.vm_image_url
  permissions = "600"
}

resource "opennebula_virtual_machine" "backend-vm" {
  count = var.vm_backend_count
  name = "backend-vm-${count.index + 1}"
  description = "Backend VM #${count.index + 1}"
  cpu = 1
  vcpu = 1
  memory = 1024
  permissions = "600"
  group = "users"

  context = {
    NETWORK  = "YES"
    HOSTNAME = "$NAME"
    SSH_PUBLIC_KEY = var.vm_ssh_pubkey
  }

  os {
    arch = "x86_64"
    boot = "disk0"
  }

  disk {
    image_id = opennebula_image.os-image.id
    target   = "vda"
    size     = 6000 # 6GB
  }

  graphics {
    listen = "0.0.0.0"
    type   = "vnc"
  }

  nic {
    network_id = 3
  }

  connection {
    type = "ssh"
    user = "root"
    host = self.ip
    private_key = file(var.vm_ssh_privkey_path)
  }

  provisioner "file" {
    source = "init-scripts"
    destination = "/tmp/init"
  }

  provisioner "remote-exec" {
    inline = [
      "export INIT_USER=${var.vm_admin_user}",
      "export INIT_PUBKEY='${var.vm_ssh_pubkey}'",
      "export INIT_HOSTNAME=${self.name}",
      "sh /tmp/init/vm.sh",
      "sh /tmp/init/user.sh",
      "sh /tmp/init/finish.sh",
    ]
  }

  tags = {
    role = "backend"
  }
}

resource "opennebula_virtual_machine" "loadbalancer-vm" {
  count = 1
  name = "loadbalancer-vm"
  description = "LoadBalancer VM"
  cpu = 1
  vcpu = 1
  memory = 1024
  permissions = "600"
  group = "users"

  context = {
    NETWORK  = "YES"
    HOSTNAME = "$NAME"
    SSH_PUBLIC_KEY = var.vm_ssh_pubkey
  }

  os {
    arch = "x86_64"
    boot = "disk0"
  }

  disk {
    image_id = opennebula_image.os-image.id
    target   = "vda"
    size     = 6000 # 6GB
  }

  graphics {
    listen = "0.0.0.0"
    type   = "vnc"
  }

  nic {
    network_id = 3
  }

  connection {
    type = "ssh"
    user = "root"
    host = self.ip
    private_key = file(var.vm_ssh_privkey_path)
  }

  provisioner "file" {
    source = "init-scripts"
    destination = "/tmp/init"
  }

  provisioner "remote-exec" {
    inline = [
      "export INIT_USER=${var.vm_admin_user}",
      "export INIT_PUBKEY='${var.vm_ssh_pubkey}'",
      "export INIT_HOSTNAME=${self.name}",
      "sh /tmp/init/vm.sh",
      "sh /tmp/init/user.sh",
      "sh /tmp/init/finish.sh",
    ]
  }

  tags = {
    role = "loadbalancer"
  }
}

output "backend_vm" {
  value = opennebula_virtual_machine.backend-vm.*.ip
}

output "loadbalancer_vm" {
  value = opennebula_virtual_machine.loadbalancer-vm.*.ip
}

resource "local_file" "inventory" {
  content = templatefile("inventory.tmpl",
    {
      vm_admin_user = var.vm_admin_user,
      backend_vm = opennebula_virtual_machine.backend-vm.*.ip,
      loadbalancer_vm = opennebula_virtual_machine.loadbalancer-vm.*.ip
    })
  filename = "./ansible/inventory.ini"
}