variable "pve_node" {
  type    = string
  default = "pve"
}
variable "pve_ip" {
  type    = string
  default = "10.0.1.1"
}
variable "pve_pool" {
  type    = string
  default = "local-zfs"
}
variable "pve_template" {
  type    = string
  default = "debian11-generic"
}
variable "hosts" {
  type = map(object({
    hostname = string
    cpu      = number
    ram      = number
    hdd      = string
    template = string
    macaddr  = string
    ip       = string
  }))
}
