# Build a Docker Image for FastAPI

This directory contains the companion code for the Docker 101 tutorial
**How to Build a Docker Image from a Dockerfile**.

It carries forward the FastAPI application and the same `Dockerfile` from
**How to Write Your First Dockerfile for FastAPI**. This tutorial focuses on
the next stage of the Docker workflow: using that definition to build a local
container image.

## Files

- `main.py` — a small FastAPI service that listens on port `8080`
- `requirements.txt` — pinned FastAPI and Uvicorn dependencies
- `Dockerfile` — the unchanged image definition from the previous tutorial

## Prerequisites

Install Docker Desktop or Docker Engine and make sure Docker is running. The
first build also requires network access so Docker can download any missing
layers for the `python:3.11-slim` base image.

## Open the example directory

From the root of this repository, run:

```bash
cd tutorials/04-build-fastapi-image
```

The final `.` in the build command below sets this directory as the build
context. Docker can therefore read its default `Dockerfile`, `main.py`, and
`requirements.txt`.

## Build the image

Build the FastAPI image in the `rkrispin` Docker Hub namespace, give it the
repository name `docker-for-ai-fastapi`, and assign the tag `0.1`:

```bash
docker build -t rkrispin/docker-for-ai-fastapi:0.1 .
```

Replace `rkrispin` with your Docker Hub username if you plan to push the image
to a repository under your account.

A successful build ends with output showing that Docker exported the image and
named it `docker.io/rkrispin/docker-for-ai-fastapi:0.1`. Exact step numbers,
timings, and cache messages can differ between systems and builds.

## Confirm the image exists

List the local image by its repository name and tag:

```bash
docker images rkrispin/docker-for-ai-fastapi:0.1
```

The output should include `rkrispin/docker-for-ai-fastapi:0.1`—or show
`rkrispin/docker-for-ai-fastapi` and `0.1` in separate repository and tag
columns—along with an image ID and size. The exact columns depend on the Docker
version and the configured image store. The image ID and size can also differ
by platform.

At this point, the image exists locally, but it has not been published and no
container has been created or started. The next tutorial will push this image
to Docker Hub.

## Troubleshoot common Docker build errors

If the image does not build, start with the error closest to the end of the
output. The following problems are common during a first build.

### Docker cannot connect to the daemon

An error such as “Cannot connect to the Docker daemon” means the Docker CLI
cannot reach Docker Engine. Start Docker Desktop or the Docker Engine service,
wait until it is ready, and run the build command again.

### Docker cannot find the Dockerfile

If Docker reports that it cannot locate `Dockerfile`, confirm that you changed
into the example directory before running the build:

```bash
cd tutorials/04-build-fastapi-image
```

The filename is case-sensitive on Linux. It should be `Dockerfile` with a
capital `D` and no file extension.

### A `COPY` instruction cannot find a file

An error involving `requirements.txt` or `main.py` usually means the selected
build context does not contain that file. Confirm that the final `.` is present
in the build command and that all three project files are in the current
directory.

### Docker cannot resolve or download the base image

Errors while loading metadata for `python:3.11-slim` can indicate a network,
DNS, proxy, Docker Hub availability, or registry-access problem. Confirm that
Docker has network access and try the build again after resolving the reported
connection issue.

### `pip` cannot install a dependency

The dependency installation step also requires network access unless its inputs
are already cached. Read the `pip` error in the build output; it may identify an
unavailable package version, connection failure, or platform compatibility
problem.

## References

- [Docker build command](https://docs.docker.com/reference/cli/docker/buildx/build/)
- [Docker build context](https://docs.docker.com/build/concepts/context/)
- [Docker Hub official Python image](https://hub.docker.com/_/python)
- [`docker images` command](https://docs.docker.com/reference/cli/docker/image/ls/)
