
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
```

### 2. Verify Docker and FLOCI

Check Docker:

```bash
docker --version
docker compose version
```

Check the Docker network:

```bash
docker network ls
```

Check whether FLOCI responds:

```bash
curl http://localhost:4566
```

### 3. Build the Tools Image

```bash
docker build -t build-break-tools:1.0 .
```

This builds the Docker image containing Terraform and the AWS CLI.

### 4. Start the Tools Container

```bash
./lab.sh
```

The script starts an interactive container with the repository mounted at `/workspace`.

### 5. Verify the Installed Tools

Inside the container, run:

```bash
terraform version
aws --version
```

To exit the container:

```bash
exit
```

## Configuration

The tools container uses `compose.yaml` to configure:

- The mounted project directory
- AWS CLI profile settings
- The default AWS region
- The FLOCI endpoint
- The Docker network used to reach FLOCI

The current configuration expects FLOCI to be reachable inside the Docker network at:

`http://awsfloci-floci-1:4566`

If your FLOCI container or network uses a different name, update `compose.yaml` accordingly.

## Finding Experiments

Experiments are organized into individual directories within this repository.

### 1. Browse the Repository

Visit the [AWS Build & Break Lab repository](https://github.com/jasserv/aws-build-break-lab) and look for directories numbered by experiment, such as `01-first-bucket`.

Each experiment directory may contain:
- `README.md` - Experiment objectives, instructions, and expected results.
- `main.tf` - Terraform configuration for the experiment.
- Supporting files and scripts required to run or reset the experiment.

### 2. List Available Experiments

From the repository root, run:

```bash
ls -d [0-9][0-9]-*/

## Troubleshooting

### Docker Network Not Found

Ensure FLOCI is running and the expected Docker network exists:

```bash
docker network ls
```

### FLOCI Connection Failure

Verify that the simulator is running and that the endpoint and Docker network configuration are correct.

### AWS Credential Errors

Verify the configured AWS profile and credentials. Use simulator credentials for local labs rather than real AWS account credentials.

### Terraform Provider Download Errors

Check Docker's network connectivity and retry the initialization.

## Security

- Never commit real AWS credentials, access keys, or secrets.
- Keep Terraform state files and local credentials out of version control.
- Use the local simulator for experiments rather than production AWS resources.

## License

For educational and personal learning purposes.
