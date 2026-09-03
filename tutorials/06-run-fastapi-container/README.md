# Run a FastAPI Application in a Docker Container

This directory contains the companion code for the Docker 101 tutorial
**How to Run a Docker Container from an Image**.

It carries forward the FastAPI application and image definition from
**How to Build a Docker Image from a Dockerfile**. The previous tutorial
published the tagged image to Docker Hub. This tutorial focuses on the next
stage of the Docker workflow: using `docker run` to create and start a
container from the image, publish its API port, and verify the response.

## Files

- `main.py` — a small FastAPI service that listens on port `8080`
- `requirements.txt` — pinned FastAPI and Uvicorn dependencies
- `Dockerfile` — the unchanged image definition from the previous tutorial

## Prerequisites

Install Docker Desktop or Docker Engine and make sure Docker is running.

The tutorial starts with the image built in the previous tutorial:

```text
rkrispin/docker-for-ai-fastapi:0.1
```

If you used your own Docker Hub namespace, replace `rkrispin` in the commands
below with your username.

## Open the example directory

From the root of this repository, run:

```bash
cd tutorials/06-run-fastapi-container
```

## Confirm the image exists

List the local image by its complete repository name and tag:

```bash
docker images rkrispin/docker-for-ai-fastapi:0.1
```

The output should contain the image reference, image ID, and size. Exact
columns vary by Docker version and image-store configuration.

If the image is not available locally, build it from this directory:

```bash
docker build -t rkrispin/docker-for-ai-fastapi:0.1 .
```

## Run the container

Create and start a named container in detached mode, and publish its API only
on the local machine:

```bash
docker run \
  --detach \
  --name docker-for-ai-fastapi \
  --publish 127.0.0.1:8080:8080 \
  rkrispin/docker-for-ai-fastapi:0.1
```

The three runtime options are:

- `--detach` runs the container in the background and returns the terminal
  prompt.
- `--name docker-for-ai-fastapi` gives the container a predictable name.
- `--publish 127.0.0.1:8080:8080` maps port `8080` on the local machine to
  port `8080` inside the container. Binding to `127.0.0.1` keeps this tutorial
  API reachable only from the Docker host.

The image reference must come after the runtime options.

## Confirm the container is running

```bash
docker ps --filter name=docker-for-ai-fastapi
```

The output should show a running container named `docker-for-ai-fastapi` and a
port mapping similar to `127.0.0.1:8080->8080/tcp`.

## Verify the FastAPI response

Call the root endpoint:

```bash
curl http://127.0.0.1:8080
```

Expected response:

```json
{"status":"ok","message":"hello from Docker"}
```

You can also open the following URLs in a browser:

- [FastAPI root endpoint](http://127.0.0.1:8080)
- [FastAPI interactive API documentation](http://127.0.0.1:8080/docs)

## Stop and remove the container

Stop the running process gracefully:

```bash
docker stop docker-for-ai-fastapi
```

The stopped container still exists. Remove that container without deleting
the image:

```bash
docker rm docker-for-ai-fastapi
```

Confirm that the image remains available:

```bash
docker images rkrispin/docker-for-ai-fastapi:0.1
```

## Troubleshoot common runtime errors

### The container name is already in use

Docker container names must be unique. Check whether an earlier container is
still present:

```bash
docker ps -a --filter name=docker-for-ai-fastapi
```

If it is the tutorial container and you no longer need it, stop and remove it
before running the command again.

### Port `8080` is already allocated

Another process or container is using the host port. Either stop that process
or publish a different host port while keeping the container port unchanged:

```bash
docker run \
  --detach \
  --name docker-for-ai-fastapi \
  --publish 127.0.0.1:8000:8080 \
  rkrispin/docker-for-ai-fastapi:0.1
```

With this mapping, open `http://127.0.0.1:8000`.

### The container starts and then exits

List stopped containers and read the application output:

```bash
docker ps -a --filter name=docker-for-ai-fastapi
docker logs docker-for-ai-fastapi
```

The container remains running only while its main process remains running. The
logs usually identify a startup error in the application or its configuration.

## References

- [`docker run` command](https://docs.docker.com/reference/cli/docker/container/run/)
- [Docker port publishing and mapping](https://docs.docker.com/engine/network/port-publishing/)
- [`docker ps` command](https://docs.docker.com/reference/cli/docker/container/ls/)
- [`docker stop` command](https://docs.docker.com/reference/cli/docker/container/stop/)
- [`docker rm` command](https://docs.docker.com/reference/cli/docker/container/rm/)
