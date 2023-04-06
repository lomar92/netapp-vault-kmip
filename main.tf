# Define AWS provider
provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]

}

resource "aws_eip" "vault_eip" {
  instance = aws_instance.vault_instance.id
  vpc      = true

  tags = {
    Name = "vault-eip"
  }
}

resource "aws_eip_association" "vault_eip" {
  instance_id   = aws_instance.vault_instance.id
  allocation_id = aws_eip.vault_eip.id
}

# Create instance
resource "aws_instance" "vault_instance" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  key_name                    = var.ssh_key_name
  subnet_id                   = aws_subnet.vault_subnet.id
  vpc_security_group_ids      = [aws_security_group.vault_sg.id]
  associate_public_ip_address = false

  tags = {
    name = "vault-instance"
  }
}

resource "null_resource" "configure-vault" {
  depends_on = [aws_eip_association.vault_eip]

  triggers = {
    build_number = timestamp()
  }

  provisioner "file" {
    source      = "scripts/vault_setup.sh"
    destination = "/home/ec2-user/vault_setup.sh"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = aws_eip.vault_eip.public_ip
    }
  }

  provisioner "file" {
    source      = "scripts/vault_kmip.sh"
    destination = "/home/ec2-user/vault-kmip.sh"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = aws_eip.vault_eip.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /home/ec2-user/vault_setup.sh",
      "chmod u+x /home/ec2-user/vault_kmip.sh",
      "sudo /home/ec2-user/vault_setup.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = aws_eip.vault_eip.public_ip
    }
  }

}

# # Create EBS volume for data storage
# resource "aws_ebs_volume" "vault_ebs_volume" {
#   availability_zone = aws_subnet.vault_subnet.availability_zone
#   size              = 10
#   type              = "gp2"
# }

# # Attach EBS volume to instance
# resource "aws_volume_attachment" "vault_volume_attachment" {
#   device_name = "/dev/sdf"
#   volume_id   = aws_ebs_volume.vault_ebs_volume.id
#   instance_id = aws_instance.vault_instance.id
# }