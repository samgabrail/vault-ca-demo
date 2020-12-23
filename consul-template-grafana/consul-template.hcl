vault {
  address      = "https://vault.tekanaid.com"

  # I'm using the environment variable VAULT_TOKEN instead.
  # token        = "s.xxxxxx"
  # grace        = "1s"
  unwrap_token = false
  renew_token  = true
}

syslog {
  enabled  = true
  facility = "LOCAL5"
}

template {
  source      = "/home/sam/automation/grafana/config/certs/grafana_cert.tpl"
  destination = "/home/sam/automation/grafana/config/certs/grafana_cert.pem"
  perms       = 0755
  command     = "docker restart automation_grafana_1"
}

template {
  source      = "/home/sam/automation/grafana/config/certs/grafana_key.tpl"
  destination = "/home/sam/automation/grafana/config/certs/grafana_key.pem"
  perms       = 0755
  command     = "docker restart automation_grafana_1"
}