resource "proxmox_vm_qemu" "cloudinit" {
  depends_on  = [null_resource.cloud_init_config_files]
  for_each    = var.hosts
  target_node = var.pve_node
  name        = each.value.hostname
  clone       = each.value.template
  memory      = each.value.ram * 1024
  cores       = each.value.cpu
  os_type     = "cloud-init"
  sockets     = 1
  scsihw      = "virtio-scsi-pci"
  agent       = 1
  disk {
    size    = each.value.hdd
    storage = var.pve_pool
    type    = "scsi"
    ssd     = 1
  }
  network {
    macaddr = each.value.macaddr
    model   = "virtio"
    bridge  = "prod"
  }
  ipconfig0               = "ip=${each.value.ip}/24,gw=10.0.10.254"
  searchdomain            = "sonic"
  nameserver              = "1.1.1.1"
  cicustom                = "user=local:snippets/user_data_vm-${each.key}.yml"
  cloudinit_cdrom_storage = "local"
}

data "template_file" "user_data" {
  for_each = var.hosts
  template = file("${path.module}/../cloud-init/user_data.cfg")
  vars = {
    hostname = each.value.hostname
    fqdn     = "${each.value.hostname}.${var.pve_node}.sonic"
  }
}

locals {
  vm_user_data = values(data.template_file.user_data)
  hosts        = values(var.hosts)
}

resource "local_file" "cloud_init_user_data_file" {
  count    = length(local.vm_user_data)
  content  = local.vm_user_data[count.index].rendered
  filename = "${path.module}/../cloud-init/user_data_${local.hosts[count.index].hostname}.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  count = length(local_file.cloud_init_user_data_file)
  connection {
    type  = "ssh"
    host  = var.pve_ip
    agent = true
  }
  provisioner "file" {
    source      = local_file.cloud_init_user_data_file[count.index].filename
    destination = "/var/lib/vz/snippets/user_data_vm-${local.hosts[count.index].hostname}.yml"
  }
}


# output "debug" {
# value = data.template_file.user_data
# value = local_file.cloud_init_user_data_file
# value = local.vm_user_data
# value = local.vm_user_data2
# value = local.vm_hostname
# value = null_resource.cloud_init_config_files
# value = proxmox_vm_qemu.cloudinit
# }
