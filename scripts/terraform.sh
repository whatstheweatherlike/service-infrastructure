#!/bin/bash
set -euo pipefail
set -o posix

function main {
  if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <terraform_command> [terraform_options...]"
    exit 1
  fi

  local deployer_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
  [ -z "$deployer_ip" ] && deployer_ip=$(curl https://ipinfo.io/ip)

  local cwd=$(pwd)

  local command="$1"; shift

  terraform init \
    -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
    -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" \
    -var "APPID=$APPID"

  terraform "$command" \
    -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
    -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" \
    -var "deployer_cidr=$deployer_ip/32" \
    -var "APPID=$APPID" \
    "$@"
}

main "$@"
