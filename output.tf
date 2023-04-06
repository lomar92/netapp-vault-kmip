output "vault_server_public_ip" {
  value = aws_eip.vault_eip.public_ip
}


output "ubuntu_public_ip_address" {
  value = aws_instance.client.public_ip
}

output "vault_kmip_ip" {
  value = aws_instance.vault_instance.private_ip
}