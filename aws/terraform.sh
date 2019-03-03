#!/bin/bash
set -euo pipefail
set -o posix

function main {
  if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <terraform_command> [terraform_options...]"
    exit 1
  fi

  local cwd=$(pwd)

  local command="$1"; shift

  terraform init

  terraform "$command" \
    -var-file="$cwd/variables.tfvars" \
    -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
    -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" \
    -var "APPID=$APPID" \
    "$@"
}

main "$@"
