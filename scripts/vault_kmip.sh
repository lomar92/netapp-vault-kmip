#!/bin/bash

# Schritt 1: KMIP Secrets Engine aktivieren und konfigurieren
vault secrets enable kmip
vault write kmip/config listen_addrs="0.0.0.0:5696"
vault read kmip/config
vault read kmip/ca

# Schritt 2: Scopes und Rollen erstellen
vault write -f kmip/scope/cvo
vault write kmip/scope/cvo/role/administration operation_all=true
vault read kmip/scope/cvo/role/administration

# Schritt 3: Client-Zertifikat generieren
vault write -format=json kmip/scope/cvo/role/administration/credential/generate format=pem > credential_cvo.json

# Zertifikat aus credential.json mit jq Tool extrahieren und in einer Datei namens cert.pem speichern.
jq -r '.data.certificate' < credential_cvo.json > cert_cvo.pem

# Private Key aus credential.json mit jq Tool extrahieren und in einer Datei namens cvo_key/cvofsxn.pem speichern.
jq -r '.data.private_key' < credential_cvo.json > cvo_key.pem

vault list kmip/scope/cvo/role/administration/credential

# Zeige volle Zertifikatskette an und Seriennummer einfügen nicht vergessen aus dem vorherigen Befehl!
vault read kmip/scope/cvo/role/administration/credential/lookup serial_number=<cvo_key_here>