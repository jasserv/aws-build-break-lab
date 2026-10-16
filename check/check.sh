#!/usr/bin/env bash

echo "========================================"
echo "      Build & Break AWS"
echo "      Environment Check"
echo "========================================"
echo

# Docker
if command -v docker >/dev/null 2>&1; then
    echo "✓ Docker       $(docker --version | sed 's/Docker version //')"
else
    echo "✗ Docker       Not installed"
fi

# AWS CLI
if command -v aws >/dev/null 2>&1; then
    echo "✓ AWS CLI      $(aws --version 2>&1 | awk '{print $1}' | cut -d/ -f2)"
else
    echo "✗ AWS CLI      Not installed"
fi

# Terraform
if command -v terraform >/dev/null 2>&1; then
    TERRAFORM_VERSION=$(terraform version | head -n 1)
    echo "✓ Terraform    $TERRAFORM_VERSION"
else
    echo "✗ Terraform"
fi

# FLOCI
if curl -s --connect-timeout 2 http://localhost:4566 >/dev/null 2>&1; then
    echo "✓ FLOCI        Running on localhost:4566"
else
    echo "✗ FLOCI        Not running on localhost:4566"
fi

echo
echo "========================================"
