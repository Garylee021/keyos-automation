output "keyos_public_ip" {
  value = azurerm_public_ip.keyos_vm_public_ip.ip_address
}

output "ssh_command_keyos_vm" {
  value = "ssh -i keys/id_rsa ${var.admin_username}@${azurerm_public_ip.keyos_vm_public_ip.ip_address}"
}

output "ssh_command_ubuntu_vm" {
  value = "ssh -i keys/id_rsa ${var.admin_username}@${azurerm_public_ip.ubuntu_vm_public_ip.ip_address}"
}
