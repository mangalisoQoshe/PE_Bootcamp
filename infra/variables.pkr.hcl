variable "vm_name" {
  type        = string
  description = "The name of the Virtual Machine"
}

variable "ssh_user" {
  type        = string
  description = "The username to use for SSH"
}

variable "ssh_passwd" {
  type        = string
  description = "The password to use for SSH"
  sensitive   = true
}

variable "vm_disk_size" {
  type = string
}

variable "iso_checksum_val" {
  type        = string
  description = "The checksum for the ISO file"
}

variable "iso_urls" {
  type        = list(string)
  description = "The ISO file to use for installation"
}

