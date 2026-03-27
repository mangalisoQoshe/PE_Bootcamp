packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }

    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

##################################################################################
# SOURCE
##################################################################################

source "qemu" "server" {
  # ISO configuration
  iso_urls     = "${var.iso_urls}"
  iso_checksum = "${var.iso_checksum_val}"
  disk_image   = true

  # VM configuration
  vm_name   = "${var.vm_name}.qcow2"
  disk_size = "${var.vm_disk_size}"
  memory    = "${var.memory}"
  cpus      = "${var.cpus}"

  # Display and acceleration
  accelerator = "kvm"
  headless    = "${var.headless}"


  # Network
  net_device       = "${var.net_device}"
  disk_interface   = "${var.disk_interface}"
  disk_compression = true

  # Output
  output_directory = "output_${var.vm_name}"
  format           = "qcow2"

  # SSH configuration (for provisioning)
  ssh_username         = "${var.ssh_user}"
  ssh_private_key_file = "${var.ssh_private_key}"
  # ssh_password         = "${var.ssh_passwd}"
  ssh_timeout          = "${var.ssh_timeout}"


  # Cloud-init seed ISO for initial configuration. 
  cd_files = ["cloud-init/meta-data", "cloud-init/user-data"]
  cd_label = "cidata"

  # Shutdown
  shutdown_command = "echo '${var.ssh_passwd}' | sudo -S shutdown -P now"

  communicator = "ssh"
  

  # Boot configuration
  efi_boot          = true
  efi_firmware_code = "/usr/share/OVMF/OVMF_CODE_4M.fd"
  efi_firmware_vars = "/usr/share/OVMF/OVMF_VARS_4M.fd"
  machine_type      = "q35" # required for EFI
  boot_wait         = "10s"

}

##################################################################################
# BUILD
##################################################################################

build {
  sources = ["source.qemu.server"]


  provisioner "ansible" {
    playbook_file = "./ansible/playbook.yml"
    use_proxy = false
    # extra_arguments = [
    #   "-vvv"
    # ]
  }
}
