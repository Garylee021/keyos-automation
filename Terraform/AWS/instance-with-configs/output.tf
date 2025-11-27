
output "keyos_public_ip" {
  value = aws_instance.keyos.public_ip
}

output "keyos_pub_nic_ip" {
  value = aws_network_interface.keyos_public_nic.private_ip
}

output "keyos_priv_nic_01_ip" {
  value = aws_network_interface.keyos_private_nic.private_ip
}

output "keyos_key_name" {
  value = aws_instance.keyos.key_name
}
