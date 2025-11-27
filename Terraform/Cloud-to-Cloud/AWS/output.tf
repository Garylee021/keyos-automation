
output "keyos_public_ip" {
  value = aws_instance.keyos.public_ip
}

output "ssh_command_for_keyos" {
  value = "ssh -i keys/keyos_lab_private_key.pem keyos@${aws_instance.keyos.public_ip}"
}

output "ssh_command_for_amazon_ec2" {
  value = "ssh -i keys/keyos_lab_private_key.pem ec2-user@${aws_instance.amazon_ec2_instance.public_ip}"
}
