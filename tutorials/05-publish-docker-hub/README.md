# Push a Docker Image to Docker Hub

This directory contains the companion commands for the Docker 101 tutorial
**How to Push a Docker Image to Docker Hub**.

The tutorial starts with the FastAPI image built in the previous tutorial and
publishes it to a repository under your Docker Hub namespace. It does not
create or start a container.

## Prerequisites

Before continuing, make sure you have:

- Docker Desktop or Docker Engine installed and running
- A Docker Hub account
- The local FastAPI image from
  [`04-build-fastapi-image`](../04-build-fastapi-image/)
- An internet connection that can reach Docker Hub

The example commands use Rami's Docker Hub username, `rkrispin`. Replace it
with your own Docker Hub username when publishing the image.

## Confirm the image exists locally

```bash
docker images rkrispin/docker-for-ai-fastapi:0.1
```

The output should include the image reference, its image ID, and its size. If
the image is missing, return to the build tutorial and create it before
continuing.

## Where Docker Hub enters the workflow

Docker Hub first appears during the image build through this Dockerfile
instruction:

```dockerfile
FROM python:3.11-slim
```

Because this image reference does not include another registry hostname,
Docker resolves it through Docker Hub as:

```text
docker.io/library/python:3.11-slim
```

During the build, Docker pulls any required base-image content that is not
already available locally. Publishing reverses the direction: `docker push`
uploads the tagged FastAPI image from the local image store to Docker Hub.

## Sign in to Docker Hub

```bash
docker login
```

Follow the authentication instructions Docker displays and wait for
`Login Succeeded` before continuing.

## Push the FastAPI image

```bash
docker push rkrispin/docker-for-ai-fastapi:0.1
```

Replace `rkrispin` with your Docker Hub username. A successful push ends with
the `0.1` tag and its SHA-256 digest.

The image name must use a namespace where your account has permission to push.
If you built the image without your Docker Hub username, add the required tag
before pushing:

```bash
docker tag docker-for-ai-fastapi:0.1 YOUR_DOCKER_USERNAME/docker-for-ai-fastapi:0.1
docker push YOUR_DOCKER_USERNAME/docker-for-ai-fastapi:0.1
```

## Verify the published image

Sign in to [Docker Hub](https://hub.docker.com/), open **My Hub →
Repositories**, select `docker-for-ai-fastapi`, and confirm that the **Tags**
view contains `0.1`.

The public image used by the tutorial is available in the
[`rkrispin/docker-for-ai-fastapi` repository](https://hub.docker.com/repository/docker/rkrispin/docker-for-ai-fastapi/general).

> Docker Hub supports public and private repositories. Anyone can find and
> pull an image from a public repository. Never include secrets, credentials,
> API keys, or private data in an image you intend to publish.

## Troubleshoot a denied push

If Docker reports `requested access to the resource is denied`:

- Confirm that `docker login` succeeded with the intended account.
- Confirm that the image namespace matches your Docker Hub username or an
  organization where you have permission to push.
- Confirm that the repository and tag match the local image reference shown by
  `docker images`.
- If necessary, run `docker logout`, sign in again, and retry the push.

## References

- [Docker Hub](https://docs.docker.com/docker-hub/)
- [`docker login` command](https://docs.docker.com/reference/cli/docker/login/)
- [`docker push` command](https://docs.docker.com/reference/cli/docker/image/push/)
- [Push images to Docker Hub](https://docs.docker.com/docker-hub/repos/manage/hub-images/push/)
