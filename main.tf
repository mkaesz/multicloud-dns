variable "constellix_api_key" {
}

variable "constellix_secret_key" {
}

variable "gcp_project" {
  default = "mkaesz"
}

provider "constellix" {
  apikey    = var.constellix_api_key
  secretkey = var.constellix_secret_key
}

provider "google" {
  project   = var.gcp_project 
}

resource "constellix_domain" "msk_pub" {
  name = "msk.pub"
  soa = {
    primary_nameserver = "ns41.constellix.com."
    ttl                = 1800
    refresh            = 48100
    retry              = 7200
    expire             = 1209
    negcache           = 8000
  }
}

resource "constellix_domain" "nasonlinux_org" {
  name = "nasonlinux.org"
  soa = {
    primary_nameserver = "ns41.constellix.com."
    ttl                = 1800
    refresh            = 48100
    retry              = 7200
    expire             = 1209
    negcache           = 8000
  }
}

resource "constellix_domain" "servicecontrol_io" {
  name = "servicecontrol.io"
  soa = {
    primary_nameserver = "ns41.constellix.com."
    ttl                = 1800
    refresh            = 48100
    retry              = 7200
    expire             = 1209
    negcache           = 8000
  }
}

resource "constellix_domain" "dealhalle_de" {
  name = "dealhalle.de"
  soa = {
    primary_nameserver = "ns41.constellix.com."
    ttl                = 1800
    refresh            = 48100
    retry              = 7200
    expire             = 1209
    negcache           = 8000
  }
}

resource "constellix_txt_record" "txtrecord14" {
  domain_id      = constellix_domain.dealhalle_de.id
  ttl            = 300
  name           = "_acme-challenge"
  noanswer       = false
  note           = ""
  gtd_region     = 1
  type           = "TXT"
  source_type    = "domains"
  roundrobin {
    value        = "5x"
    disable_flag = false
  }
}

resource "constellix_domain" "topdealbox_de" {
  name = "topdealbox.de"
  soa = {
    primary_nameserver = "ns41.constellix.com."
    ttl                = 1800
    refresh            = 48100
    retry              = 7200
    expire             = 1209
    negcache           = 8000
  }
}

resource "constellix_txt_record" "txtrecord13" {
  domain_id      = constellix_domain.topdealbox_de.id
  ttl            = 300
  name           = "_acme-challenge"
  noanswer       = false
  note           = ""
  gtd_region     = 1
  type           = "TXT"
  source_type    = "domains"
  roundrobin {
    value        = "GFUpmoQ81AUSm2HzAHqtAqOnOyhUXyfCMfmYoI2fHEA"
    disable_flag = false
  }
}

resource "constellix_txt_record" "txtrecord12" {
  domain_id      = constellix_domain.nasonlinux_org.id
  ttl            = 300
  name           = "_acme-challenge"
  noanswer       = false
  note           = ""
  gtd_region     = 1
  type           = "TXT"
  source_type    = "domains"
  roundrobin {
    value        = "5x-exm5KfFebO8Bi3ZsZY8ffnjhmMaVvDXb03_tTeEs"
    disable_flag = false
  }
}

resource "constellix_txt_record" "txtrecord11" {
  domain_id      = constellix_domain.servicecontrol_io.id
  ttl            = 300
  name           = "_acme-challenge"
  noanswer       = false
  note           = ""
  gtd_region     = 1
  type           = "TXT"
  source_type    = "domains"
  roundrobin {
    value        = "83q9jID9kPsbYToGd4X8DpKkXnwm4xf6rKyp_ILEiNU"
    disable_flag = false
  }
}

resource "constellix_domain" "upcloud_msk_pub" {
  name = "upcloud.msk.pub"
  soa = {
    primary_nameserver = "ns41.constellix.com."
    ttl                = 1800
    refresh            = 48100
    retry              = 7200
    expire             = 1209
    negcache           = 8000
  }
}

resource "constellix_txt_record" "txtrecord10" {
  domain_id      = constellix_domain.upcloud_msk_pub.id
  ttl            = 300
  name           = "_acme-challenge"
  noanswer       = false
  note           = ""
  gtd_region     = 1
  type           = "TXT"
  source_type    = "domains"
  roundrobin {
    value        = "bTrn6KPiThLRPVI266AWs4C086fsKMD5qonr7KxY9ks"
    disable_flag = false
  }
}

resource "constellix_cname_record" "blog" {
  domain_id      = constellix_domain.servicecontrol_io.id
  source_type    = "domains"
  record_option  = "roundRobin"
  ttl            = 300
  name           = "blog"
  host           = "servicecontrol.github.io."
  type           = "CNAME"
  gtd_region     = 1
  note           = ""
  noanswer       = false
}

resource "constellix_ns_record" "gcp" {
  domain_id      = constellix_domain.msk_pub.id
  source_type    = "domains"
  ttl            = 100
  name           = "gcp"
  roundrobin {
    value        = google_dns_managed_zone.msk-pub-zone.name_servers[0] 
    disable_flag = "false"
  }
  roundrobin {
    value        = google_dns_managed_zone.msk-pub-zone.name_servers[1]
    disable_flag = "false"
  }
  roundrobin {
    value        = google_dns_managed_zone.msk-pub-zone.name_servers[2] 
    disable_flag = "false"
  }
  roundrobin {
    value        = google_dns_managed_zone.msk-pub-zone.name_servers[3] 
    disable_flag = "false"
  }
  type           = "NS"
  gtd_region     = 1
  note           = "Delegeta to GCP"
  noanswer       = false
}

resource "google_dns_managed_zone" "msk-pub-zone" {
  name        = "gcp-msk-pub-zone"
  dns_name    = "gcp.msk.pub."
  description = "GCP msk.pub zone"
}

resource "constellix_txt_record" "txtrecord1" {
  domain_id   = constellix_domain.msk_pub.id
  ttl         = 300
  name        = "_acme-challenge"
  noanswer    = false
  note        = ""
  gtd_region  = 1
  type        = "TXT"
  source_type = "domains"
  roundrobin {
    value        = "3WKqFx9CxoLx3HW6XDxTt2Haq1ktsE8bkkg28K88ghc"
    disable_flag = false
  }
}

resource "google_dns_record_set" "spf" {
  name         = "_acme-challenge.${google_dns_managed_zone.msk-pub-zone.dns_name}"
  managed_zone = google_dns_managed_zone.msk-pub-zone.name
  type         = "TXT"
  ttl          = 300

  rrdatas = ["Zjsyox82oVRUBw6MYMIHQZxcNspHQxjCJ99GBtomXsY"]
}

resource "constellix_txt_record" "txtrecord2" {
  domain_id   = constellix_domain.msk_pub.id
  ttl         = 300
  name        = "_dmarc"
  noanswer    = false
  note        = ""
  gtd_region  = 1
  type        = "TXT"
  source_type = "domains"
  roundrobin {
    value        = "v=DMARC1; p=none; rua=mailto:mskaesz@googlemail.com"
    disable_flag = false
  }
}

resource "constellix_txt_record" "txtrecord3" {
  domain_id   = constellix_domain.msk_pub.id
  ttl         = 300
  name        = "mailo._domainkey.mg"
  noanswer    = false
  note        = ""
  gtd_region  = 1
  type        = "TXT"
  source_type = "domains"
  roundrobin {
    value        = "k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAydSloKeNf2DHz1GyvBragSV5Ef+MA/wuah5+lJ/w1Ma1djbk+aKgayi6T9qL1lmNQoVYmfCpmbe6lntEOhMj9MNU77zGU6yI22iCfYOpT0RFuynJB6ZkyqkYyp8F013keg2lfzcTNH2tlTEymEA91pcXd5EKX+Npi6jNyI6cMtjgwzQ2jY+2xYS3dNp5jhtj/8Txj0D9U9L4ASG4bIvWRcmLHWFLEN4mE20tRGoemlLehFwz2t5LjmaLVzlTgYHLbBpCLfsnPt+SAfUX1YD18EHDNVGwHxplqhfKQxbAw/kRO3qAd9Q9qAwAovF2A/vw+9pK2N6SdmIZYGQUsvIftQIDAQAB"
    disable_flag = false
  }
}

resource "constellix_txt_record" "txtrecord4" {
  domain_id   = constellix_domain.msk_pub.id
  ttl         = 300
  name        = "mg"
  noanswer    = false
  note        = ""
  gtd_region  = 1
  type        = "TXT"
  source_type = "domains"
  roundrobin {
    value        = "v=spf1 include:eu.mailgun.org ~all"
    disable_flag = false
  }
}

resource "constellix_txt_record" "txtrecord5" {
  domain_id   = constellix_domain.msk_pub.id
  ttl         = 300
  name        = ""
  noanswer    = false
  note        = ""
  gtd_region  = 1
  type        = "TXT"
  source_type = "domains"
  roundrobin {
    value        = "protonmail-verification=1252b210149f6550ec351fe4ca11ffe6190a6c9e"
    disable_flag = false
  }
  roundrobin {
    value = "v=spf1 include:_spf.protonmail.ch mx ~all"
    disable_flag = false
  }      
}

resource "constellix_txt_record" "txtrecord6" {
  domain_id   = constellix_domain.msk_pub.id
  ttl         = 300
  name        = "protonmail._domainkey"
  noanswer    = false
  note        = ""
  gtd_region  = 1
  type        = "TXT"
  source_type = "domains"
  roundrobin {
    value        = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC5ZyNgqtQ/8LV22uaxt9AM88j+WaMv4Xmwrp4MQPdWPyZLjprDzKZziPe+8g3DpdryCKeJSdAnCf6cc/1Nh008VbNoXPInspbL/W1dGzOr06ivyPgevW/J18XLpz2Cg5xmCarXGXOg7oQdfFo9fiti3qx7EiQA9eIL2r7+w36OuQIDAQAB"
    disable_flag = false
  }
}

resource "constellix_mx_record" "mx1" {
  domain_id   = constellix_domain.msk_pub.id
  source_type = "domains"
  name        = "mg"
  ttl         = "300"
  noanswer    = false
  note        = ""
  gtd_region  = 1
  type        = "MX"
  roundrobin {
    value        = "mxa.eu.mailgun.org."
    level        = "10"
    disable_flag = "false"
  }
  roundrobin {
    value        = "mxb.eu.mailgun.org"
    level        = "10"
    disable_flag = "false"
  }
}

resource "constellix_mx_record" "mx2" {
  domain_id   = constellix_domain.msk_pub.id
  source_type = "domains"
  name        = ""
  ttl         = "108000"
  noanswer    = false
  note        = ""
  gtd_region  = 1
  type        = "MX"
  roundrobin {
    value        = "mail.protonmail.ch."
    level        = "10"
    disable_flag = "false"
  }
  roundrobin {
    value        = "mailsec.protonmail.ch."
    level        = "20"
    disable_flag = "false"
  }
}

resource "constellix_cname_record" "mailgun" {
  domain_id     = constellix_domain.msk_pub.id
  source_type   = "domains"
  record_option = "roundRobin"
  ttl           = 300
  name          = "email.mg"
  host          = "eu.mailgun.org."
  type        = "CNAME"
  gtd_region  = 1
  note        = ""
  noanswer    = false
}

resource "constellix_spf_record" "spf1" {
  domain_id   = constellix_domain.msk_pub.id
  source_type = "domains"
  name        = ""
  ttl         = 10
  noanswer    = false
  gtd_region  = 1
  type        = "SPF"
  note        = ""
  roundrobin {
    value        = "v=spf1 include:_spf.protonmail.ch mx ~all"
    disable_flag = "false"
  }
}
