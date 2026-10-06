#!/bin/sh

set -eu

BASE_IMAGE=${1:-python:3.11-slim}
APPLICATION_IMAGE=${2:-docker-for-ai-fastapi:layers}

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker is not available on PATH." >&2
  exit 1
fi

if ! docker image inspect "$BASE_IMAGE" >/dev/null 2>&1; then
  echo "Error: base image '$BASE_IMAGE' is not available locally." >&2
  echo "Pull or build it before running this script." >&2
  exit 1
fi

if ! docker image inspect "$APPLICATION_IMAGE" >/dev/null 2>&1; then
  echo "Error: application image '$APPLICATION_IMAGE' is not available locally." >&2
  echo "Build it before running this script." >&2
  exit 1
fi

TEMP_DIRECTORY=$(mktemp -d "${TMPDIR:-/tmp}/docker-layer-compare.XXXXXX")
BASE_LAYERS_FILE="$TEMP_DIRECTORY/base-layers.txt"
APPLICATION_LAYERS_FILE="$TEMP_DIRECTORY/application-layers.txt"

cleanup() {
  rm -f "$BASE_LAYERS_FILE" "$APPLICATION_LAYERS_FILE"
  rmdir "$TEMP_DIRECTORY" 2>/dev/null || true
}

trap cleanup EXIT HUP INT TERM

docker image inspect \
  --format '{{range .RootFS.Layers}}{{println .}}{{end}}' \
  "$BASE_IMAGE" | sed '/^$/d' > "$BASE_LAYERS_FILE"

docker image inspect \
  --format '{{range .RootFS.Layers}}{{println .}}{{end}}' \
  "$APPLICATION_IMAGE" | sed '/^$/d' > "$APPLICATION_LAYERS_FILE"

BASE_LAYER_COUNT=$(wc -l < "$BASE_LAYERS_FILE" | tr -d ' ')
APPLICATION_LAYER_COUNT=$(wc -l < "$APPLICATION_LAYERS_FILE" | tr -d ' ')

if [ "$APPLICATION_LAYER_COUNT" -lt "$BASE_LAYER_COUNT" ]; then
  echo "Error: the application image has fewer layers than the base image." >&2
  exit 1
fi

LAYER_NUMBER=1
while IFS= read -r BASE_LAYER; do
  APPLICATION_LAYER=$(sed -n "${LAYER_NUMBER}p" "$APPLICATION_LAYERS_FILE")

  if [ "$BASE_LAYER" != "$APPLICATION_LAYER" ]; then
    echo "Error: layer $LAYER_NUMBER does not match." >&2
    echo "The application image does not extend this exact base image." >&2
    echo "Rebuild it after pulling the selected base tag." >&2
    exit 1
  fi

  LAYER_NUMBER=$((LAYER_NUMBER + 1))
done < "$BASE_LAYERS_FILE"

echo "Base image:        $BASE_IMAGE ($BASE_LAYER_COUNT filesystem layers)"
echo "Application image: $APPLICATION_IMAGE ($APPLICATION_LAYER_COUNT filesystem layers)"
echo
echo "The application image reuses every base filesystem layer in the same order."
echo

awk -v base_count="$BASE_LAYER_COUNT" '
  NR <= base_count {
    printf "%2d  inherited    %s\n", NR, $0
    next
  }

  {
    printf "%2d  application  %s\n", NR, $0
  }
' "$APPLICATION_LAYERS_FILE"

ADDED_LAYER_COUNT=$((APPLICATION_LAYER_COUNT - BASE_LAYER_COUNT))

echo
echo "Inherited layers:   $BASE_LAYER_COUNT"
echo "Application layers: $ADDED_LAYER_COUNT"
