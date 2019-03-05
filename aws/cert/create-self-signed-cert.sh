#!/bin/bash
set -euo pipefail
set -o posix

function usage {
    cat << EOF
$0 - create a self signed certificate for usage with TLS/SSL

Usage: $0 [<domain> [<key-pwd>]]
EOF

}

function main {
    if [ "$#" -gt 0 ]; then
        if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
            usage
            exit 1
        fi
    fi

    local domain
    [ "$#" -gt 0 ] && domain="$1"; shift || domain="cert"
    local password
    [ "$#" -gt 0 ] && password="$1"; shift || password="$WHATSTHEWEATHERLIKE_RSA_KEY_PWD"

    trap "rm -f $domain.key.password $domain.csr $domain.key $domain.crt key.pem.tmp" SIGINT SIGTERM EXIT

    openssl genrsa -out "$domain.key" -passout "pass:$password" 2048
    openssl req -nodes -newkey rsa -keyout "$domain.key" -out "$domain.csr" -passin "pass:$password" \
            -config openssl.cnf

    cp "$domain.key" "$domain.key.password"
    openssl rsa -in "$domain.key.password" -out "$domain.key"
    openssl x509 -req -days 365 -in "$domain.csr" -signkey "$domain.key" -out "$domain.crt"

    # conversion for aws to pem
    openssl rsa -in "$domain.key" -text -out "key.pem.tmp"
    cat "key.pem.tmp" | tail -n 27 > "key.pem"
    openssl x509 -inform PEM -in "$domain.crt" -outform pem -out "cert.pem"
}

main "$@"
