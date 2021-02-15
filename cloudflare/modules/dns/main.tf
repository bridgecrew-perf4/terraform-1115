terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

resource "cloudflare_zone" "dns_domain" {
    zone   = var.zone
    paused = false
    plan   = "free"
    type   = "full"
}

resource "cloudflare_record" "dns_record" {
    # for_each = {for r in var.records: index(var.records, r) => r}
    for_each  =  var.records
    
    zone_id   = cloudflare_zone.dns_domain.id
    name      = each.value.name
    type      = each.value.type
    ttl       = each.value.ttl
    proxied   = each.value.proxied
    value     = each.value.value
    priority  = can(each.value.priority) ? each.value.priority : null
}

output "dns_result" {
    value = [cloudflare_zone.dns_domain, cloudflare_record.dns_record]
    description = "Show results about ZONE and its records"
}
output "records" {
  value = [ { for_each = var.records } ]
  description = "Show information about tfvars included from -var-file="
}