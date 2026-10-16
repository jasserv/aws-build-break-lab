#!/usr/bin/env bash
set -e

# Move to the folder containing this script
cd "$(dirname "$0")"

# Start the disposable tools container
docker compose run --rm lab-tools
