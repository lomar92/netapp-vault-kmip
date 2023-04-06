# !/bin/bash

# Installieren des jq Tools
sudo yum install -y jq

# Installieren von Vault
curl --remote-name "https://releases.hashicorp.com/vault/1.12.3+ent/vault_1.12.3+ent_linux_amd64.zip"

unzip vault_1.12.3+ent_linux_amd64.zip

sudo mv vault /usr/local/bin/

complete -C /usr/local/bin/vault vault

# Verwendung von mlock
sudo setcap cap_ipc_lock=+ep /usr/local/bin/vault

sudo mkdir --parents /etc/vault.d

sudo touch /etc/vault.d/vault.hcl
sudo chmod 777 /etc/vault.d/vault.hcl

sudo mkdir /opt/raft
sudo chmod 777 /opt/raft

# Konfiguration von Vault
## Hinzufügen einer Enterprise-Lizenz
sudo touch /etc/vault.d/license.hclic
echo "VAULT_LICENSE" | sudo tee /etc/vault.d/license.hclic

## Vault-Konfigurationsdatei
sudo cat > /etc/vault.d/vault.hcl << EOF
storage "raft" {
  path = "/opt/raft"
  node_id = "node1"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"
}

enterprise {
  license_path = "/etc/vault.d/license.hclic"
}

auto_snapshot {
  enabled = true
}

disable_mlock = true
license_path = "/etc/vault.d/license.hclic"
api_addr = "http://127.0.0.1:8200"
cluster_addr = "http://127.0.0.1:8201"
ui = true 
EOF


sudo touch /etc/systemd/system/vault.service
sudo chmod 777 /etc/systemd/system/vault.service

sudo cat << EOF > /etc/systemd/system/vault.service
[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/vault.hcl
StartLimitIntervalSec=60
StartLimitBurst=3
[Service]
User=ec2-user
Group=ec2-user
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
LimitNOFILE=65536
LimitMEMLOCK=infinity
[Install]
WantedBy=multi-user.target
EOF

sudo cat << EOF > /etc/profile.d/vault.sh
export VAULT_ADDR='http://0.0.0.0:8200'
EOF

sudo systemctl enable vault.service --now
# sudo systemctl start vault.service
# sudo systemctl status vault.service

# Diese Befehle ausführen: 
# vault operator init -key-threshold=1 -key-shares=1 -format=json > vault.txt

### Ohne Systemd Service!
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# on your vault vm_instance :
# export VAULT_ADDR='http://0.0.0.0:8200' // on your local machine export VAULT_ADDR=<public/private_ip>

## start vault server without systemd service
# vault server -config /etc/vault.d/vault.hcl

# neue ssh tab aufmachen und auf vault vm ssh connecten
# vault operator init -key-threshold=1 -key-shares=1 -format=json > vault.txt

# cat vault.txt 
## --> kopiere unseal_keys_b64 

# cat vault.txt | jq -r .root_token > token.txt

# vault operator unseal 

# prompt: vault_unseal_key
# export VAULT_TOKEN=$(cat token.txt)

# überprüfe Lizenzsschlüssel 
## --> vault license get

# vault login $VAULT_TOKEN
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

# Diese Vault Befehle durchführen, beim Neu-Start der Vault VM
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# on your vault instance :
# export VAULT_ADDR='http://0.0.0.0:8200'
# start vault server: vault server -config /etc/vault.d/vault.hcl
# cat vault.txt --> kopiere unseal_keys_b64 
# vault operator unseal 
# prompt: vault_unseal_key
# export VAULT_TOKEN=$(cat token.txt)
# überprüfe Lizenzsschlüssel --> vault license get
# vault login $VAULT_TOKEN
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
