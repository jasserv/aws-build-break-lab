# AWS Build & Break Lab

A hands-on AWS learning lab for practicing Terraform, S3, IAM permissions, and troubleshooting access-denied errors using a local AWS simulator.

The goal is to understand how cloud resources and permissions work by building a working configuration, testing it, intentionally breaking it, and restoring it.

## What You'll Learn

- Provision AWS-style resources using Terraform.
- Understand S3 buckets, objects, and IAM policies.
- Distinguish bucket ARNs from object ARNs.
- Test read-only permissions using the AWS CLI.
- Troubleshoot `AccessDenied` errors.
- Understand how explicit IAM denies affect access.
- Practice restoring a known-good infrastructure configuration.

## Lab 01: First Bucket

This lab provisions:

- An S3 bucket named `lab-data-bucket`
- A sample object named `hello.txt`
- An IAM user named `lab-reader`
- An access key for the lab user
- A policy that permits listing the bucket and downloading objects, but not uploading them

The lab uses Terraform and the AWS CLI inside Docker. AWS API requests are sent to a local FLOCI simulator rather than a real AWS account.

## Requirements

- Windows with WSL 2, or a compatible Linux environment
- Docker Desktop or Docker Engine
- Git
- A running FLOCI simulator listening on port `4566`
- The Docker network and simulator hostname configured in `compose.yaml`

This repository expects the existing Docker network `awsfloci_default` and the simulator hostname `awsfloci-floci-1`. If your FLOCI installation uses different names, update `compose.yaml` and the Terraform endpoint configuration to match your environment.

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/jasserv/aws-build-break-lab.git
cd aws-build-break-lab
