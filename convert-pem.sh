#!/bin/bash
# Convert the root and int certs from .pem to .crt to be used in the Windows Certificate Store
openssl x509 -outform der -in output/root_ca/ca_cert.pem -out output/root_ca/ca_cert.crt
openssl x509 -outform der -in output/int_ca/int_cert.pem -out output/int_ca/int_cert.crt