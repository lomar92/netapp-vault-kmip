terraform {
  required_providers {
    netapp-cloudmanager = {
      source  = "NetApp/netapp-cloudmanager"
      version = "23.1.1"
    }
  }
}

provider "netapp-cloudmanager" {
  refresh_token = var.cloudmanager_refresh_token
  sa_secret_key = var.cloudmanager_sa_secret_key
  sa_client_id  = var.cloudmanager_sa_client_id
}

resource "netapp-cloudmanager_connector_aws" "cl-occm-aws" {
  provider      = netapp-cloudmanager
  name          = "OCM"
  region        = "eu-central-1"
  key_name      = var.ssh_key_name
  company       = "HashiCorp"
  instance_type = "t3.xlarge"
  aws_tag {
    tag_key = "cloud-manager-connector-aws"
  }

  subnet_id                 = aws_subnet.vault_subnet.id
  security_group_id         = aws_security_group.vault_sg.id
  iam_instance_profile_name = "AdminAccess"
  account_id                = "account-8MEUiBUe"
}

resource "netapp-cloudmanager_cvo_aws" "cvo-svm-aws" {
  provider          = netapp-cloudmanager
  name              = "svm_free"
  region            = "eu-central-1"
  subnet_id         = aws_subnet.vault_subnet.id
  vpc_id            = aws_vpc.vault_vpc.id
  security_group_id = aws_security_group.vault_sg.id
  aws_tag {
    tag_key   = "kmip"
    tag_value = "test"
  }
  aws_tag {
    tag_key   = "kmip"
    tag_value = "test"
  }
  cluster_key_pair_name = var.ssh_key_name
  svm_password          = "password1234"
  client_id             = netapp-cloudmanager_connector_aws.cl-occm-aws.client_id
  writing_speed_state   = "NORMAL"
  capacity_package_name = "Freemium"
  instance_type         = "m5.xlarge"
  ebs_volume_size       = "500"
  ebs_volume_size_unit  = "GB"
}

resource "netapp-cloudmanager_volume" "cvo-volume-nfs" {
  provider                  = netapp-cloudmanager
  volume_protocol           = "nfs"
  name                      = "encryption_volume"
  size                      = 10
  unit                      = "GB"
  provider_volume_type      = "gp2"
  export_policy_type        = "custom"
  export_policy_ip          = ["0.0.0.0/0"]
  export_policy_nfs_version = ["nfs4"]
  snapshot_policy_name      = "sp1"
  snapshot_policy {
    schedule {
      schedule_type = "5min"
      retention     = 10
    }
    schedule {
      schedule_type = "hourly"
      retention     = 5
    }
  }
  working_environment_id = netapp-cloudmanager_cvo_aws.cvo-svm-aws.id
  client_id              = netapp-cloudmanager_connector_aws.cl-occm-aws.client_id
}