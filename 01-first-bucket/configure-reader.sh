#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if ! terraform output -raw reader_access_key >/dev/null 2>&1; then
  echo "Error: Reader credentials not found."
  echo "Run terraform apply first."
  exit 1
fi

TF_KEY="$(terraform output -raw reader_access_key)"
TF_SECRET="$(terraform output -raw reader_secret_key)"

mkdir -p /workspace/.lab-aws
umask 077

cat > /workspace/.lab-aws/credentials <<CREDS
[reader]
aws_access_key_id = $TF_KEY
aws_secret_access_key = $TF_SECRET
CREDS

chmod 600 /workspace/.lab-aws/credentials
unset TF_KEY TF_SECRET

echo "Reader profile configured successfully."
