data "libvirt_domain_interface_addresses" "ubuntu" {
  domain = libvirt_domain.vm.name
  source = "lease" # optional: "lease" (DHCP), "agent" (qemu-guest-agent), or "any"
}
output "vm_name" {
  value = libvirt_domain.vm.name
}

output "vm_ip" {
  description = "IP address of the VM"
  value       = length(data.libvirt_domain_interface_addresses.ubuntu.interfaces) > 0 && length(data.libvirt_domain_interface_addresses.ubuntu.interfaces[0].addrs) > 0 ? data.libvirt_domain_interface_addresses.ubuntu.interfaces[0].addrs[0].addr : "No IP address found"
}