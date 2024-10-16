provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "ubuntu" {
  name = "ubuntu2"
  type = "dir"
  path = var.libvirt_disk_path
}

resource "libvirt_volume" "bigdata-vm-qcow2" {
  count  = var.instance_count
  name   = "bigdata-vm-qcow2-${count.index}"
  pool   = libvirt_pool.ubuntu.name
  source = var.ubuntu_img_url
  format = "qcow2"
}

data "template_file" "user_data" {
  template = file("${path.module}/config/cloud_init.yml")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  # count = var.instance_count
  # name  = "commoninit-${count.index}.iso"
  name = "commoninit.iso"
  pool  = libvirt_pool.ubuntu.name

  user_data      = data.template_file.user_data.rendered
}

resource "libvirt_domain" "domain-bigdata-vm" {
  count  = var.instance_count
  name   = "${var.vm_hostname}-${count.index}"
  memory = "2048"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
    hostname       = "${var.vm_hostname}-${count.index}"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.bigdata-vm-qcow2[count.index].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
