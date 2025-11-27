
output "keyos_01_public_ip" {
  value = aws_instance.keyos_01.public_ip
}

output "keyos_02_public_ip" {
  value = aws_instance.keyos_02.public_ip
}

output "data_vpc_instance_public_ip" {
  value = aws_instance.data_vpc_instance.public_ip
}

output "ssh_command_for_keyos_01" {
  value = "ssh -i keys/keyos_lab_private_key.pem keyos@${aws_instance.keyos_01.public_ip}"
}

output "ssh_command_for_keyos_02" {
  value = "ssh -i keys/keyos_lab_private_key.pem keyos@${aws_instance.keyos_02.public_ip}"
}

output "ssh_command_for_data_vpc_instance" {
  value = "ssh -i keys/keyos_lab_private_key.pem ec2-user@${aws_instance.data_vpc_instance.public_ip}"
}