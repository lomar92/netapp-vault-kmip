data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "owner-id"
    values = ["099720109477"] # Canonical
  }
}

resource "aws_instance" "client" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.ssh_key_name

  vpc_security_group_ids      = [aws_security_group.vault_sg.id]
  subnet_id                   = aws_subnet.vault_subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "client-ubuntu-vm"
  }
## Hier noch mkdir ändern auf home/user/encryption - da es ein Verzeichnis für den Nutzer sein soll
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nfs-common
              mkdir /home/ubuntu/encryption_volume
              sudo chown -R ubuntu:ubuntu /home/ubuntu/encryption_volume
              sudo echo "key" >> /home/ubuntu/vault_ssh_key.pem
              EOF
}
## HIER NOCH Private Key mitgeben, weil ubuntu client auch als Jump Host fungiert für ssh ONTAP