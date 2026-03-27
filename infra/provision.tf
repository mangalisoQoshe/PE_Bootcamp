module "tf_vm" {
    source = "git@github.com:mangalisoQoshe/tf-kvm-vm.git"
    base_image_name = "ubuntu-cloud.qcow2"
    vm_name = "ubuntu-vm"
    base_image_path = "golden-images_pkr/output_ubuntu_cloud/ubuntu_cloud.qcow2"
    vm_disk_name = "ubuntu-cloud-vol.qcow2"
} 


output "vm_name" {
  value = module.tf_vm.vm_name
}

output "vm_ip" {
  value = module.tf_vm.vm_ip
}
