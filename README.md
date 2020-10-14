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
