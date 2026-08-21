#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
image_ref="${1:-docker-for-ai-fastapi:0.1}"

docker build --tag "$image_ref" "$script_dir"
