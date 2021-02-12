module "dns" {
  source  = "./modules/dns/"
  zone    = var.zone
  records = var.records
}