# Terraform outputs if you want to do something more with these certs in terraform.
output "ca_cert_chain"  {
    value = vault_pki_secret_backend_root_sign_intermediate.intermediate.ca_chain
}

output "intermediate_ca" {
    value = vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate
}

output "intermediate_key"  {
    value = vault_pki_secret_backend_intermediate_cert_request.intermediate.private_key
}