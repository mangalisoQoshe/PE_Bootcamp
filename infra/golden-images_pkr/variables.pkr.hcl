variable "boot_command" {
  type        = list(string)
  description = "Boot command for Ubuntu 24.04.4 server"
  default = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ipv6.disable=1 ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot<enter>"
  ]
}

variable "cpus" {
  type    = number
  default = 2
}

variable "disk_interface" {
  type    = string
  default = "virtio"
}

variable "headless" {
  type        = bool
  description = "Display GUI"
  default     = false
}

variable "http_dir" {
  type        = string
  description = "HTTP server for autoinstall files"
  default     = "http"
}

variable "iso_checksum_val" {
  type        = string
  description = "The checksum for the ISO file"
}

variable "iso_urls" {
  type        = list(string)
  description = "The ISO file to use for installation"
}

variable "memory" {
  type    = number
  default = 3048
}

variable "net_device" {
  type    = string
  default = "virtio-net"
}

variable "ssh_passwd" {
  type        = string
  description = "The password to use for SSH"
  sensitive   = true
}

variable "ssh_private_key" {
  type        = string
  description = "The path to the private key used for SSH authentication"
  default     = "~/.ssh/rpi"
  sensitive   = true
}

variable "ssh_timeout" {
  type    = string
  default = "20m"
}

variable "ssh_user" {
  type        = string
  description = "The username to use for SSH"
}

variable "vm_disk_size" {
  type = string
}

variable "vm_name" {
  type        = string
  description = "The name of the Virtual Machine"
}