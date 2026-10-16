# AWS Build & Break Lab

A containerized toolkit for practicing cloud infrastructure and security labs using Terraform and the AWS CLI with a local FLOCI simulator.

## Tools Included

- **Terraform**: Infrastructure as Code
- **AWS CLI**: Interact with AWS-compatible APIs
- **Docker**: Run tools in an isolated, consistent environment
- **FLOCI**: Local AWS service simulator

## Prerequisites

- Windows with WSL 2 or Linux
- Docker Desktop or Docker Engine
- Git
- A running FLOCI simulator

The current configuration expects the Docker network `awsfloci_default` and simulator hostname `awsfloci-floci-1`.

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/jasserv/aws-build-break-lab.git
cd aws-build-break-lab
