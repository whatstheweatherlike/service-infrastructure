resource "cloudflare_record" "CNAME__30c0e33308510402c9b4391093f82287_api_whatstheweatherlike_io_557f02b0a10501a338020215399ebf1f" {
    domain = "whatstheweatherlike.io"

    name = "${data.terraform_remote_state.aws.weather_service_certificate_record_name}"
    type = "${data.terraform_remote_state.aws.weather_service_certificate_record_type}"
    ttl = "1"
    proxied = "false"

    value = "${data.terraform_remote_state.aws.weather_service_certificate_record_value}"

    lifecycle {
        ignore_changes = ["value"]
    }
}

resource "cloudflare_record" "CNAME_api_whatstheweatherlike_io_4b85a764886bc978832d07506e63bbba" {
    domain = "whatstheweatherlike.io"

    name = "api.whatstheweatherlike.io"
    type = "CNAME"
    ttl = "1"
    proxied = "false"

    value = "${data.terraform_remote_state.aws.weather_service_dns_name}"
}


resource "cloudflare_record" "CNAME_email_whatstheweatherlike_io_4c43d8fbacadbb3201f9cd3b037e7ec0" {
    domain = "whatstheweatherlike.io"

    name = "email.whatstheweatherlike.io"
    type = "CNAME"
    ttl = "1"
    proxied = "true"

    value = "mailgun.org"
}


resource "cloudflare_record" "CNAME_whatstheweatherlike_io_b74b6c1c7c5fd2be90e4b9eba80da9ed" {
    domain = "whatstheweatherlike.io"

    name = "whatstheweatherlike.io"
    type = "CNAME"
    ttl = "1"
    proxied = "true"

    value = "www.whatstheweatherlike.io"
}


resource "cloudflare_record" "CNAME_www_whatstheweatherlike_io_3c89433e61898738fd14f444da6f9dbc" {
    domain = "whatstheweatherlike.io"

    name = "www.whatstheweatherlike.io"
    type = "CNAME"
    ttl = "1"
    proxied = "true"

    value = "whatstheweatherlike.github.io"
}


resource "cloudflare_record" "MX_whatstheweatherlike_io_36a971225717b0a6db1b51dc7f65ab53" {
    domain = "whatstheweatherlike.io"

    name = "whatstheweatherlike.io"
    type = "MX"
    ttl = "1"
    proxied = "false"

    priority = "10"

    value = "mxa.mailgun.org"
}


resource "cloudflare_record" "MX_whatstheweatherlike_io_70c73391dd7da12e72ab9d9aff0b2a79" {
    domain = "whatstheweatherlike.io"

    name = "whatstheweatherlike.io"
    type = "MX"
    ttl = "1"
    proxied = "false"

    priority = "10"

    value = "mxb.mailgun.org"
}


resource "cloudflare_record" "TXT_k1__domainkey_whatstheweatherlike_io_cb7f4e21afd22ff15d8fe34682a5f3b0" {
    domain = "whatstheweatherlike.io"

    name = "k1._domainkey.whatstheweatherlike.io"
    type = "TXT"
    ttl = "1"
    proxied = "false"

    value = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDBfmE8UgGGzQwSP+2eNv6rtxP4xFdXYd3q7cnwI11/H1jOO/LMRS2H0N2WuS8QxDGXipLvHiyC0BlZxQyYYq9R5WyDRP4gJEM4aZ+ZIuS7MINif3IfPaLD+cfYgmHLYjS4W2g6Y6ixGful7lYjcQaO3cqVMCiRpa106DHcgJTQjQIDAQAB"
}


resource "cloudflare_record" "TXT_whatstheweatherlike_io_dc41e4a52c8098c0bc155ea3eb50e7b1" {
    domain = "whatstheweatherlike.io"

    name = "whatstheweatherlike.io"
    type = "TXT"
    ttl = "1"
    proxied = "false"

    value = "v=spf1 include:mailgun.org ~all"
}