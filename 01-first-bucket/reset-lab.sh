#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "================================"
echo " Resetting S3 IAM Experiment"
echo "================================"

echo "[1/4] Removing temporary test files..."
rm -f test.txt denied-test.txt
rm -f hello.txt

echo "[2/4] Restoring known-good Terraform configuration..."
cp main.tf.good main.tf

echo "[3/4] Applying Terraform configuration..."
terraform apply -auto-approve

echo "[4/4] Refreshing reader credentials..."
./configure-reader.sh

echo
echo "Reset complete. Verify the baseline:"
echo "  aws s3 ls s3://lab-data-bucket/ --profile reader"
echo "  aws s3 cp s3://lab-data-bucket/hello.txt - --profile reader"
