terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "2.14.0"
    }
  }
}

provider "vault" {
  # Configuration options
}
