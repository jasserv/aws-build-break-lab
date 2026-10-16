#!/bin/bash

set -e

echo "================================"
echo " Resetting S3 IAM Experiment"
echo "================================"

echo "[1/3] Deleting experiment files..."
rm -f test.txt
rm -f hello.txt

echo "[2/3] Restoring main.tf..."
cp main.tf.good main.tf

echo "[3/3] Applying clean Terraform configuration..."
terraform apply -auto-approve

echo
echo "================================"
echo " Reset complete!"
echo "================================"
