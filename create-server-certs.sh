#!/bin/bash
# pass the name of the cert as the first argument to the script, common name as second argument, ip_sans as third, and TTL in seconds as fourth. Example: `./create-server-certs.sh grafana docker01.home 192.168.1.80 31556952`
# Create the Client and Server certs.  There are terraform interfaces to do this, but it seems a bit 
# clunky, with state management etc.  We could want to generate certs on a regular basis, we probably
# don't want the certs saved in any state files etc.  So I generate certs with the CLI.
# Create the Server Certs
set -eu

echo Creating cert for $1
echo Common name: $2
echo IP Sans: $3
echo TTL: $4

source ./env-vars.sh

mkdir -p output/$1

vault write pki-int-ca/issue/server-cert-for-home ttl=$4 common_name="$2" ip_sans="$3" -format=json > output/$1.json

cat output/$1.json | jq -r '.data.certificate' > output/$1/$1_cert.pem
cat output/$1.json | jq -r '.data.private_key' > output/$1/$1_key.pem
cat output/$1.json | jq -r '.data.issuing_ca' > output/$1/ca.pem
cat output/$1.json | jq -r '.data.ca_chain[]' > output/$1/ca_chain.pem

# Dump the certificates in text mode
openssl x509 -noout -text -in output/$1/ca.pem > output/$1/ca.pem.txt 
openssl x509 -noout -text -in output/$1/$1_cert.pem > output/$1/$1_cert.pem.txt