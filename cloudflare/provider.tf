terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

variable "CLOUDFLARE_EMAIL" {}
variable "CLOUDFLARE_KEY" {}
variable "CLOUDFLARE_ACCOUNT_ID" {}

provider "cloudflare" {
  # Configuration options
  email      = var.CLOUDFLARE_EMAIL
  api_key    = var.CLOUDFLARE_KEY
  account_id = var.CLOUDFLARE_ACCOUNT_ID
}