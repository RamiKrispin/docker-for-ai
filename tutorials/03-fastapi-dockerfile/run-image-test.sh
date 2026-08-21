#!/usr/bin/env bash

set -euo pipefail

docker run --rm -d \
  --name docker-for-ai-fastapi \
  -p 8080:8080 \
  docker-for-ai-fastapi:0.1
