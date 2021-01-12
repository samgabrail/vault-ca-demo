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

## Commands to clear CRL cache in Windows 10
[Based on this](https://social.technet.microsoft.com/Forums/windowsserver/en-US/59758544-d5a2-4c0c-ace0-0bd9fb711c08/revoked-certificate-showing-valid)

To view the CRL Cache:
```shell
certutil -urlcache crl
```
To Clear it:
```shell
certutil -setreg chain\ChainCacheResyncFiletime @now
```

## Main PKI Demo Steps
1. Run Terraform to create the Root and Intermediate CAs using Vault's PKI Secrets Engine
2. Generate a leaf certificate for Grafana
3. Add the cert to Grafana and reload the Docker container
4. Show on Chrome that the browser doesn't trust the cert
5. Add the root and intermediate CA certs to the Windows Certificate Store
6. Show how Chrome now trusts the Grafana certificate
7. Revoke the certificate
8. Show how Chrome now shows you that the cert is revoked and you can't proceed

## Automated Cert Renewal Demo Steps
1. ![Diagram](https://viewer.diagrams.net/?highlight=0000ff&edit=_blank&layers=1&nav=1&title=Automate%20Certificate%20Renewals#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D12dYhK276bENJjRsS3zNmnZIUTsQ5LyhF%26export%3Ddownload)
2. Create a Vault PKI policy
```shell
path "pki-int-ca/issue/server-cert-for-home" {
  capabilities = ["update"]
}
```
`vault policy write pki pki.hcl`
2. Generate a Vault Token `vault token create -policy="pki" -period=24h -orphan` and put it in a file called token.txt
3. Consul-template config file
4. Template files for grafana
5. Start consul-template `consul-template -config consul-template.hcl -vault-agent-token-file=token.txt`
6. Show how the cert is valid for 30 seconds
7. Wait to show how it's invalid
8. Refresh to show the new valid time/date
9. Change to 90 days cert ttl