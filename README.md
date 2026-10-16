
# AWS Build & Break Lab

A containerized toolkit for practicing cloud infrastructure and security labs using Terraform and the AWS CLI with a local FLOCI simulator.

## Tools Included

- **Terraform**: Infrastructure as Code
- **AWS CLI**: Interact with AWS-compatible APIs
- **Docker**: Run tools in an isolated, consistent environment
- **Docker Compose**: Start and connect the tools container and FLOCI simulator
- **FLOCI**: Local AWS service simulator

## Prerequisites

- Windows with WSL 2 or Linux
- Docker Desktop or Docker Engine
- Git
- A running FLOCI simulator

You do not need to install Terraform or the AWS CLI directly on your host machine. Both are available inside the tools container.

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/jasserv/aws-build-break-lab.git
cd aws-build-break-lab
```

### 2. Build the Tools Image

```bash
docker build -t build-break-tools:1.0 .
```

This builds the container image containing Terraform and the AWS CLI.

### 3. Start the Lab

```bash
./lab.sh
```

The script starts an interactive tools container and mounts the repository at `/workspace`. Docker Compose also starts the FLOCI simulator and connects both containers to the same Docker network.

### 4. Verify the Installed Tools

Inside the container, run:

```bash
terraform version
aws --version
```

The tools container uses the internal FLOCI endpoint:

```text
http://floci:4566
```

To leave the tools container, run:

```bash
exit
```

### 5. Run the Environment Checks

From your host terminal, run:

```bash
./check/check.sh
```

This checks the local prerequisites and verifies that the FLOCI endpoint is responding.

## Configuration

The lab's `compose.yaml` configures the tools container and FLOCI simulator, including:

- The mounted project directory
- The internal Docker network
- The default AWS region
- The AWS CLI endpoint
- The Terraform FLOCI endpoint
- The location of local lab credentials
- Environment settings that disable EC2 metadata credential lookups

### FLOCI Endpoints

The endpoints differ depending on where you run your commands.

| Location | Endpoint |
|---|---|
| Host machine | `http://localhost:4567` |
| Tools container | `http://floci:4566` |

Use the host endpoint when checking FLOCI from WSL or your host terminal. Commands executed inside the tools container use the internal service hostname.

The Compose configuration manages the network between the containers, so you do not need to connect the lab to a separately named FLOCI container or an existing Docker network.

## Finding Experiments

Experiments are organized into numbered directories in the repository.

### 1. Browse Available Experiments

From the repository root, run:

```bash
ls -d [0-9][0-9]-*/
```

Example output:

```text
01-first-bucket/
```

### 2. Inspect an Experiment

Each experiment directory may contain:

- `README.md` — Objectives, instructions, and expected results.
- `main.tf` — Terraform configuration.
- `main.tf.good` — Known-good configuration used to restore the baseline.
- `configure-reader.sh` — Configures the experiment's reader profile when applicable.
- `reset-lab.sh` — Restores the experiment's known-good configuration.
- Other scripts and files needed for testing.

Before starting an experiment, read its README and identify the resources it creates, the permissions it grants, and the expected outcomes.

### Terraform State or Configuration Problems

Read the experiment instructions before changing state or deleting files. If a reset script is provided, use it rather than manually deleting Terraform state.

## Security

- Never commit real AWS credentials, access keys, or secrets.
- Keep local credential files, Terraform state files, and generated plans out of version control.
- Use the local simulator for experiments instead of production AWS resources.
- Treat simulator credentials and local state as sensitive lab artifacts.
- Review Terraform plans before applying infrastructure changes.

## Project Goals

This project is designed to make cloud learning repeatable and practical. The goal is to make it easier to set up the environment on another machine, spend less time repeating manual configuration, and focus more on building, breaking, troubleshooting, and understanding cloud infrastructure.

## License

For educational and personal learning purposes.
