
# External Key Manager Configuration

This Terraform code deploys an instance of HashiCorp Vault and Cloud Volumes ONTAP on AWS. With this code, you can quickly and easily deploy an External Key Management Server with KMIP Secrets Engine and a running Instance of NetApp's Cloud Volumes ONTAP for encrypted volumes and aggregates in AWS.


## 1. Requirements
- An AWS account with the necessary permissions to create AWS resources.
- Terraform Version 1.0 or higher.
- [Vault Enterprise License](https://www.hashicorp.com/products/vault/pricing)
- [BlueXP Refresh Token](https://services.cloud.netapp.com/refresh-token)
- [BlueXP Service Account Key & Client ID](https://console.bluexp.netapp.com/credentials/user-credentials#accountManagement)
- [NetApp Support Site Account](https://docs.netapp.com/us-en/cloud-manager-setup-admin/task-adding-nss-accounts.html)
- A client machine that acts as a jump host for configuring NetApp Cloud Volumes ONTAP. Provided in code. 
- Your AWS Public & Private Key for SSH


## 2. Preparation

Download or Fork KMIP Project

```bash
git clone https://github.com/lomar92/netapp-vault-kmip
cd vault-netapp-kmip
```

Prepare Terraform Variables 
```bash
touch terraform.tfvars
```

```javascript
aws_region                 = "your-region"
vpc_cidr_block             = "10.0.0.0/16"
subnet_cidr_block          = "10.0.1.0/24"
ssh_key_name               = "name_of_your_key_in_aws"
vault_version              = "1.12.3+ent"
vault_license              = "ENTERPRISE_LICENSE"
private_key_path           = "PATH_TO_PRIVATE_KEY"
cloudmanager_refresh_token = "YOUR_BLUEXP_TOKEN"
cloudmanager_sa_secret_key = "Service_Account_Secret_Key"
cloudmanager_sa_client_id  = "Service_Account_Client_ID"
```

Initiliaze your Working Directory 
```bash
terraform init 
```

Review the planned infrastructure changes and confirm them or just run Terraform apply!

```bash
terraform apply --auto--aprove
```
Now go for a Coffe and wait for 30minutes until your deployment is finished.

#### Deployed Ressources 
- AWS VPC with Networking and required Ports
- Jump Host, that acts also as a client machine for mounting encrypted volume from Cloud Volumes ONTAP
- HashiCorp Vault Instance - Single Node Instance
- Cloud Volumes ONTAP on AWS 

#### Outputs: 
- Public IP Vault Server
- Ubuntu Public IP (client)
- Vault KMIP Server Private IP

## 3. HashiCorp Vault & KMIP Setup Documentation

[Follow this KMIP Setup Instructions on Medium](https://medium.com/hashicorp-engineering/hashicorp-vault-as-an-external-key-manager-for-cloud-volumes-ontap-9ba85bb5a2bd)