output "Public_IP_of_our_Vault_Server" {
  value = aws_eip.vault_eip.public_ip
}


output "Ubuntu_Client_Public_IP_act_as_a_jump_host_for_ONTAP_connectivitiy" {
  value = aws_instance.client.public_ip
}

output "Vault_KMIP_Server_Private_IP" {
  value = aws_instance.vault_instance.private_ip
}