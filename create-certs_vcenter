#!/bin/bash
# Create the Client and Server certs.  There are terraform interfaces to do this, but it seems a bit 
# clunky, with state management etc.  We could want to generate certs on a regular basis, we probably
# don't want the certs saved in any state files etc.  So I generate certs with the CLI.
# Create the Server Certs
set -eu
mkdir -p output/vcenter-certs

vault write -tls-skip-verify pki-int-ca/issue/server-cert-for-mydomain.com ttl=31556952 common_name="vcenter.mydomain.com" ip_sans="127.0.0.1" -format=json > output/vcenter_certs.json

cat output/vcenter_certs.json | jq -r '.data.certificate' > output/vcenter-certs/vcenter.pem
cat output/vcenter_certs.json | jq -r '.data.private_key' > output/vcenter-certs/vcenter_key.pem
cat output/vcenter_certs.json | jq -r '.data.issuing_ca' > output/vcenter-certs/ca.pem
cat output/vcenter_certs.json | jq -r '.data.ca_chain[]' > output/vcenter-certs/ca_chain.pem

# Dump the certificates in text mode
openssl x509 -noout -text -in output/vcenter-certs/ca.pem > output/vcenter-certs/ca.pem.txt 
openssl x509 -noout -text -in output/vcenter-certs/vcenter.pem > output/vcenter-certs/vcenter.pem.txt
