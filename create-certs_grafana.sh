#!/bin/bash
# Create the Client and Server certs.  There are terraform interfaces to do this, but it seems a bit 
# clunky, with state management etc.  We could want to generate certs on a regular basis, we probably
# don't want the certs saved in any state files etc.  So I generate certs with the CLI.
# Create the Server Certs
set -eu
mkdir -p output/grafana-certs

vault write pki-int-ca/issue/server-cert-for-home ttl=31556952 common_name="SynologyNAS.home" ip_sans="192.168.1.8" -format=json > output/grafana_certs.json

cat output/grafana_certs.json | jq -r '.data.certificate' > output/grafana-certs/grafanacert.pem
cat output/grafana_certs.json | jq -r '.data.private_key' > output/grafana-certs/grafana_key.pem
cat output/grafana_certs.json | jq -r '.data.issuing_ca' > output/grafana-certs/ca.pem
cat output/grafana_certs.json | jq -r '.data.ca_chain[]' > output/grafana-certs/ca_chain.pem

# Dump the certificates in text mode
openssl x509 -noout -text -in output/grafana-certs/ca.pem > output/grafana-certs/ca.pem.txt 
openssl x509 -noout -text -in output/grafana-certs/grafanacert.pem > output/grafana-certs/grafanacert.pem.txt

# Convert the root and int certs from .pem to .crt to be used in the Windows Certificate Store
openssl x509 -outform der -in output/root_ca/ca_cert.pem -out output/root_ca/ca_cert.crt
openssl x509 -outform der -in output/int_ca/int_cert.pem -out output/int_ca/int_cert.crt
