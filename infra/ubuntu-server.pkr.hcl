packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

##################################################################################
# SOURCE
##################################################################################

source "qemu" "ubuntu" {
  # ISO configuration
  iso_urls     = "${var.iso_urls}"
  iso_checksum = "${var.iso_checksum_val}"

  # VM configuration
  vm_name   = "${var.vm_name}.qcow2"
  disk_size = "${var.vm_disk_size}"
  memory    = 2048
  cpus      = 2

  # Display and acceleration
  accelerator = "kvm"
  headless    = "true"


  # Network
  net_device     = "virtio-net"
  disk_interface = "virtio"

  # Output
  output_directory = "output_${var.vm_name}"
  format           = "qcow2"

  # SSH configuration (for provisioning)
  ssh_username = "${var.ssh_user}"
  ssh_password = "${var.ssh_passwd}"
  ssh_timeout  = "20m"

  # HTTP server for autoinstall files
  http_directory = "http"

  # Shutdown
  shutdown_command = "echo '${var.ssh_passwd}' | sudo -S shutdown -P now"

  # Boot configuration
  boot_wait = "5s"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot<enter>"
  ]
}

##################################################################################
# BUILD
##################################################################################

build {
  sources = ["source.qemu.ubuntu"]
}
