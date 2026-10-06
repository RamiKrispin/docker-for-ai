# Understand How Docker Image Layers Are Stacked

This directory contains the companion code for the Docker 101 tutorial
**Understand How Docker Image Layers Are Stacked**.

The example compares `python:3.11-slim` with a FastAPI image built directly on
top of it. A comparison script verifies that the base image's filesystem
layers are reused unchanged, then labels the additional application layers.

## Files

- `compare-layers.sh` — compares the ordered `RootFS.Layers` lists for a base
  image and an application image

The FastAPI Dockerfile and build context remain in
`../04-build-fastapi-image`.

## Prerequisites

Install Docker Desktop or Docker Engine and make sure Docker is running. The
commands use a POSIX-compatible shell such as `sh`, Bash, or Zsh.

## Open the example directory

From the root of this repository, run:

```bash
cd tutorials/08-understand-image-layers
```

## Build a controlled image pair

`python:3.11-slim` is a mutable tag, so it can point to a newer base image over
time. Pull the current base image, then rebuild the FastAPI application with
`--pull`. This ensures that both local images use the same base version for the
comparison:

```bash
docker image pull python:3.11-slim

docker build \
  --pull \
  --tag docker-for-ai-fastapi:layers \
  ../04-build-fastapi-image
```

The separate `docker-for-ai-fastapi:layers` tag keeps this experiment from
replacing `rkrispin/docker-for-ai-fastapi:0.1`.

## Compare the filesystem layers

Run the comparison script with its default image names:

```bash
./compare-layers.sh
```

The output reports the layer counts and labels each application-image layer as
either `inherited` or `application`. A successful comparison includes:

```text
Base image:        python:3.11-slim
Application image: docker-for-ai-fastapi:layers

The application image reuses every base filesystem layer in the same order.
```

The complete output also lists the SHA-256 DiffID for each layer. The inherited
layers appear first and match the base image exactly. The remaining entries
belong only to the FastAPI image.

To compare different local images, pass their references as arguments:

```bash
./compare-layers.sh BASE_IMAGE APPLICATION_IMAGE
```

The application image must extend the selected base image. The script exits
with an error if the base layer list is not an exact prefix of the application
layer list.

## Connect the new layers to the Dockerfile

Display the application image history:

```bash
docker image history \
  --format 'table {{.CreatedBy}}\t{{.Size}}' \
  docker-for-ai-fastapi:layers
```

History is displayed newest first, while `RootFS.Layers` is ordered from the
base upward. Reading the Dockerfile from top to bottom, this build adds five
filesystem layers:

1. `RUN python -m venv "$VIRTUAL_ENV"` creates the virtual environment.
2. `WORKDIR /app` creates the application directory in this image.
3. `COPY requirements.txt .` adds the dependency definition.
4. `RUN python -m pip install ...` installs FastAPI, Uvicorn, and their
   dependencies.
5. `COPY main.py .` adds the application source.

The Dockerfile also contains `ENV`, `EXPOSE`, and `CMD` instructions. They
record configuration and appear in image history, but they do not add
filesystem DiffIDs to `RootFS.Layers`.

The application layers are stacked in Dockerfile order above the inherited
base layers. That order matters for build caching: when one build step changes,
Docker must reconsider that step and the steps that follow it. The next
tutorial measures this behavior directly.

## Limits and cleanup

- Layer identifiers and sizes vary by platform and base-image version.
- History sizes describe individual changes and should not be added blindly to
  reproduce the image size reported by every image store.
- A matching layer prefix proves filesystem-layer reuse for this image pair; it
  does not provide vulnerability, provenance, or software-inventory analysis.

Remove only the temporary application tag when the comparison is complete:

```bash
docker image rm docker-for-ai-fastapi:layers
```

Keep `python:3.11-slim` if other images or tutorials use it.

## References

- [Understanding Docker image layers](https://docs.docker.com/get-started/docker-concepts/building-images/understanding-image-layers/)
- [`docker image inspect` command](https://docs.docker.com/reference/cli/docker/image/inspect/)
- [`docker image history` command](https://docs.docker.com/reference/cli/docker/image/history/)
- [Docker build cache](https://docs.docker.com/build/cache/)
