{{ with secret "pki-int-ca/issue/server-cert-for-home" "ttl=30s" "common_name=docker01.home" "ip_sans=192.168.1.80" }}
{{ .Data.private_key }}
{{ end }}