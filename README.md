# Overview

This work is based on what Steve Dillon put together in [github](https://github.com/stvdilln/vault-ca-demo.git). He also has a [medium blog here.](https://medium.com/@stvdilln/creating-a-certificate-authority-with-hashicorp-vault-and-terraform-4d9ddad31118)

You can also opt to use the CLI, API, or Web UI to run commands to configure Vault for PKI [using this guide.](https://learn.hashicorp.com/tutorials/vault/pki-engine)

This repo demonstrates:

* How to run vault locally with TLS options
* How to Create a Self Signed cert in Terraform using the resource tls_self_signed_cert
* How to use various vault_pki* resources:
  * vault_pki_secret_backend_config_urls
  * tls_self_signed_cert
  * tls_private_key
  * vault_pki_secret_backend_config_ca
  * vault_pki_secret_backend_intermediate_cert_request
  * vault_pki_secret_backend_root_sign_intermediate
  * vault_pki_secret_backend_intermediate_set_signed
* How to use a Vault Certificate Authority to create Client and Server TLS certs.
* How to bootstrap a Vault instance to make it its own Certificate Authority


## Running everything

1. Run env-vars.sh to export the VAULT_ADDR and VAULT_TOKEN Environment Variables
2. Run `Terraform apply` to create the Root and Intermediate CA along with roles in Vault.
3. Next to create leaf certificates: Run `./create-server-certs.sh <cert_name> <common_name> <ip_sans> <TTL in seconds>` Example: `./create-server-certs.sh grafana docker01.home 192.168.1.80 31556952`

## Moving Certs
Command to scp from local to remote machine examples
```shell
scp -r /mnt/c/Users/Sam/Deployments/HashiCorp/Vault/vault-ca-demo/output/grafana sam@192.168.1.80:/home/sam/automation/grafana/config/certs
scp -r /mnt/c/Users/Sam/Deployments/HashiCorp/Vault/vault-ca-demo/output/homeassistant sam@192.168.1.80:/home/sam/automation/HomeAssistant/certs
```

## Importing Certs into the Windows Cert Store
The `convert-pem.sh` script will automatically convert the Intermediate and Root Certs into the `.crt` format to be imported into the Windows Certificate Store

In the Microsoft Management Console (mmc):
- You will need to import the root ca cert into the Trusted Root Certification Authorities -> Certificates folder 
- Also import the intermediate ca cert into the Intermediate Certification Authorities -> Certificates folder
- Reboot the computer (I tried restarting the Chrome browser, but that didn't work)

## Revocation
You can revoke a certificate by following this example:
```shell
vault write pki-int-ca/revoke serial_number="62:d3:ac:77:93:25:34:11:e0:47:27:0f:d1:db:92:67:51:8c:30:3c"
```

You can also remove a revoked certificate and clean the CRL by:
```shell
vault write pki_int/tidy tidy_cert_store=true tidy_revoked_certs=true
```