#!/bin/bash
# pass the name of the cert as the first argument to the script Example: `create-certs.sh grafana-cert`
# Create the Client and Server certs.  There are terraform interfaces to do this, but it seems a bit 
# clunky, with state management etc.  We could want to generate certs on a regular basis, we probably
# don't want the certs saved in any state files etc.  So I generate certs with the CLI.
# Create the Server Certs
set -eu

echo Creating cert for $1

source ./env-vars.sh

mkdir -p output/$1

vault write pki-int-ca/issue/server-cert-for-home ttl=31556952 common_name="SynologyNAS.home" ip_sans="192.168.1.8" -format=json > output/$1.json

cat output/$1.json | jq -r '.data.certificate' > output/$1/grafanacert.pem
cat output/$1.json | jq -r '.data.private_key' > output/$1/grafana_key.pem
cat output/$1.json | jq -r '.data.issuing_ca' > output/$1/ca.pem
cat output/$1.json | jq -r '.data.ca_chain[]' > output/$1/ca_chain.pem

# Dump the certificates in text mode
openssl x509 -noout -text -in output/$1/ca.pem > output/$1/ca.pem.txt 
openssl x509 -noout -text -in output/$1/grafanacert.pem > output/$1/grafanacert.pem.txt

# Convert the root and int certs from .pem to .crt to be used in the Windows Certificate Store
openssl x509 -outform der -in output/root_ca/ca_cert.pem -out output/root_ca/ca_cert.crt
openssl x509 -outform der -in output/int_ca/int_cert.pem -out output/int_ca/int_cert.crt
