# Overview

This work is based on what Steve Dillon put together in [github](https://github.com/stvdilln/vault-ca-demo.git). He also has a [medium blog here.](https://medium.com/@stvdilln/creating-a-certificate-authority-with-hashicorp-vault-and-terraform-4d9ddad31118)

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
2. Run `Terraform apply`
3. Run `./create-certs_grafana.sh`

Command to scp from local to remote machine examples
```shell
scp -r /mnt/c/Users/Sam/Deployments/HashiCorp/Vault/vault-ca-demo/output/grafana sam@192.168.1.80:/home/sam/automation/grafana/config/certs
scp -r /mnt/c/Users/Sam/Deployments/HashiCorp/Vault/vault-ca-demo/output/homeassistant sam@192.168.1.80:/home/sam/automation/HomeAssistant/certs
```

## Importing Certs into the Windows Cert Store
The `create-certs_grafana.sh` script will automatically convert the Intermediate and Root Certs into the `.crt` format to be imported into the Windows Certificate Store

In the Microsoft Management Console (mmc):
- You will need to import the root ca cert into the Trusted Root Certification Authorities -> Certificates folder 
- Also import the intermediate ca cert into the Intermediate Certification Authorities -> Certificates folder
- Reboot the computer (I tried restarting the Chrome browser, but that didn't work)