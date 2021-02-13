zone = "sonic.net.pl"

records = {
  0 = {
    name = "localhost"
    type = "A"
    ttl = "1"
    proxied = "false"
    value = "127.0.0.1"
  },
  1 = {
    name = "mail"
    type = "A"
    ttl = "1"
    proxied = "false"
    value = "88.198.23.35"
  },
  2 = {
    name = "sonic.net.pl"
    type = "A"
    ttl = "1"
    proxied = "true"
    value = "85.221.204.254"
  },
  3 = {
    name = "angelika"
    type = "CNAME"
    ttl = "1"
    proxied = "true"
    value = "sonic.net.pl"
  },
  4 = {
    name = "konrad"
    type = "CNAME"
    ttl = "1"
    proxied = "true"
    value = "sonic.net.pl"
  },
  5 = {
    name = "www"
    type = "CNAME"
    ttl = "1"
    proxied = "true"
    value = "sonic.net.pl"
  },
  6 = {
    name = "sonic.net.pl"
    type = "MX"
    ttl = "1"
    proxied = "false"
    value = "mail.sonic.net.pl"
    priority = "10"
  },
  7 = {
    name = "_dmarc"
    type = "TXT"
    ttl = "1"
    proxied = "false"
    value = "v=DMARC1; p=none; rua=mailto:admin@sonic.net.pl; ruf=mailto:admin@sonic.net.pl; sp=none; fo=1; ri=7; adkim=r; aspf=r"
  },
  8 = {
    name = "_domainkey"
    type = "TXT"
    ttl = "1"
    proxied = "false"
    value = "o=~"
  },
  9 = {
    name = "sonic.net.pl"
    type = "TXT"
    ttl = "1"
    proxied = "false"
    value = "v=spf1 a mx a:s6.linuxpl.com ipv4:88.198.23.35 ip4:109.199.70.95 ip4:46.248.186.213 ip4:46.248.186.212 include:_spf.google.com ~all" 
  },
  10 = {
    name = "sonic.net.pl"
    type = "TXT"
    ttl = "1"
    proxied = "false"
    value = "google-site-verification=70lZ2iHYCcE8FUhtIFCNcSwDfTjOYQpFvk8wjL6CC5U"
  },
  11 = {
    name = "x._domainkey"
    type = "TXT"
    ttl = "1"
    proxied = "false"
    value = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzlUbZWOcUB1J1+2AJP+GX7Q6zvnSa4DRwBKjBw5s9x/F+aKH/nru50JoAVj7fqntmc7Xo2cY+mEUB9JNOSpBmZczb9CxmIhTe1yvHXmPMPbtSGnb6BsFFjjhpE0/qUY5ZadY/GUYo1WaTLnqZ7tkVkUrinfcYUdtvoUffy1JefsU37Y1kOTeeSx5Zx4gvhzLhImStdRaCwD+/IpyvFkGgr2S+oe9J3eDYvwQNkNmewlxLno7W5l4npKc4CjO1hVJcYL0yGHslIEIabetKu2DtGYz2ycyrOf0WV1iyavRd9vZ9dk5bnX/eBM9Bhi5SuWupCyNialKsHvNZDA0q1RhtQIDAQAB"
  }
}