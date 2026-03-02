# Base Image built by Packer
resource "libvirt_volume" "base_image" {
  name = "ubuntu_24.04.4-server.qcow2"
  pool = "default"

  target = {
    format = {
      type = "qcow2"
    }
 
  }


  create = {
    content = {
      url = "/home/mangaliso/Codebase/PE_Bootcamp/infra/packer/output_ubuntu_24.04.4-server/ubuntu_24.04.4-server.qcow2"
    }
  }
}

# Create VM disk from base image
resource "libvirt_volume" "vm_disk" {
  name     = "ubuntu-vm.qcow2"
  pool     = "default"
  capacity = 25 * 1024 * 1024 * 1024 # 25G

  target = {
    format = {
      type = "qcow2"
    }

  }

  backing_store = {


    path = libvirt_volume.base_image.path
    format = {
      type = "qcow2"
    }

  }

}


# Network
resource "libvirt_network" "virt_network" {
  name      = "virt-network"
  autostart = true
  forward = {
    mode = "nat"
  }
  ips = [
    {
      address = "10.0.0.1"
      prefix  = "24"
      dhcp = {
        ranges = [
          {
            start = "10.0.0.20"
            end   = "10.0.0.30"
          }
        ]
      }
    }
  ]
}

# VM Domain 
resource "libvirt_domain" "vm" {
  name        = "ubuntu-vm"
  memory      = 1024
  memory_unit = "MiB"
  vcpu        = 1
  type        = "kvm"


os = {
  type            = "hvm"
  type_arch       = "x86_64"
  type_machine    = "q35"
  firmware        = "efi"
  loader          = "/usr/share/OVMF/OVMF_CODE_4M.fd"
  loader_format   = "raw"
  loader_readonly = "yes"
  loader_secure   = "no"
  loader_type     = "pflash"
}
    features = {
    acpi = true
  }

  devices = {

    disks = [
      # Main OS disk
      {
        source = {
          volume = {
            pool   = libvirt_volume.vm_disk.pool
            volume = libvirt_volume.vm_disk.name
          }
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
         driver = {
           type  = "qcow2"
          #  cache = "writeback"
         }
      }
    ]

    # Network interfaces
    interfaces = [
      {
        
        model = { type = "virtio" }

        source = {
          network = {
            network = libvirt_network.virt_network.name
          }
        }
        wait_for_ip = {
          timeout = 300
          source  = "any"
        }

      }
    ]
    graphics = [{
      vnc = {
        autoport = "yes"
        listen   = "127.0.0.1"
      }
    }]

    consoles = [
      { type = "pty", target = { type = "serial", port = 0 } }
    ]


  }
   cpu = {
    mode = "host-passthrough"
  }

  running = true

}


