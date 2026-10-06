# Inspect a Docker Image

This directory contains the companion commands for the Docker 101 tutorial
**How to Inspect a Docker Image**.

The example continues with the FastAPI image built and used earlier in the
series. It introduces `docker image inspect` for metadata and runtime
configuration, then shows where Docker exposes build-history and filesystem-
layer information. The next tutorial explains how those layers are structured.

## Prerequisites

Install Docker Desktop or Docker Engine and make sure Docker is running. The
tutorial uses this image:

```text
rkrispin/docker-for-ai-fastapi:0.1
```

If a different Docker Hub namespace was used in the earlier tutorials, replace
`rkrispin` in the commands below with that namespace.

## Open the example directory

From the root of this repository, run:

```bash
cd tutorials/07-image-inspect-layers
```

## Confirm the image is available

```bash
docker image ls rkrispin/docker-for-ai-fastapi:0.1
```

Expected output resembles:

```text
IMAGE                                ID             DISK USAGE   CONTENT SIZE   EXTRA
rkrispin/docker-for-ai-fastapi:0.1   ff9fc74692a6        309MB           67MB
```

The image name may reflect a different namespace. The image ID, column names,
and reported sizes can also vary between Docker versions and image stores.

If the image is missing, build it from the fourth tutorial's files:

```bash
docker build \
  --tag rkrispin/docker-for-ai-fastapi:0.1 \
  ../04-build-fastapi-image
```

## Inspect the complete image metadata

`docker image inspect` returns detailed metadata and configuration for one or
more local images. Docker returns a JSON array because the command accepts more
than one image reference.

```bash
docker image inspect rkrispin/docker-for-ai-fastapi:0.1
```

The main parts of the output are:

- `Id`, `RepoTags`, and `RepoDigests` identify the image and its references.
- `Created`, `Architecture`, `Os`, and `Size` describe the build and platform.
- `Config` contains runtime defaults such as environment variables, the working
  directory, exposed ports, and the startup command.
- `RootFS.Layers` contains the filesystem-layer identifiers.

The `Config` values align with the Dockerfile: port `8080/tcp` comes from
`EXPOSE 8080`, `python main.py` comes from `CMD`, `/app` comes from `WORKDIR`,
and the environment values come from the `ENV` instructions or the base image.

Inspecting an image is read-only. It does not create a container or start the
FastAPI application.

## Focus on the main metadata

Use `--format` to select a smaller set of fields:

```bash
docker image inspect --format 'Image ID: {{.Id}}
Tags: {{json .RepoTags}}
Created: {{.Created}}
Platform: {{.Os}}/{{.Architecture}}
Size: {{.Size}} bytes
Working directory: {{.Config.WorkingDir}}
Command: {{json .Config.Cmd}}
Exposed ports: {{json .Config.ExposedPorts}}
Filesystem layers: {{len .RootFS.Layers}}' \
  rkrispin/docker-for-ai-fastapi:0.1
```

The exact ID, creation time, platform, size, and layer count depend on when and
where the image was built. The expected application settings are working
directory `/app`, command `["python","main.py"]`, and exposed port `8080/tcp`.

Print the effective environment one value per line:

```bash
docker image inspect \
  --format '{{range .Config.Env}}{{println .}}{{end}}' \
  rkrispin/docker-for-ai-fastapi:0.1
```

Expected output resembles:

```text
PATH=/opt/venv/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LANG=C.UTF-8
GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D
PYTHON_VERSION=3.11.16
PYTHON_SHA256=91bcdebfdde239a003ae93738a7fce0f9230fee5c4bc2b86f6e8c6f98aabe8
VIRTUAL_ENV=/opt/venv
```

`VIRTUAL_ENV` and the modified `PATH` come from our Dockerfile. The other
values are inherited from `python:3.11-slim`, the image selected by `FROM`.

## Locate history and layer information

Display the recorded build history from newest to oldest:

```bash
docker image history \
  --format 'table {{.CreatedBy}}\t{{.Size}}' \
  rkrispin/docker-for-ai-fastapi:0.1
```

Use `--no-trunc` to display the complete recorded command text:

```bash
docker image history --no-trunc \
  rkrispin/docker-for-ai-fastapi:0.1
```

Some history rows may display `<missing>` instead of an image ID. This does not
mean that the final image is incomplete.

Print the filesystem-layer identifiers:

```bash
docker image inspect \
  --format '{{range .RootFS.Layers}}{{println .}}{{end}}' \
  rkrispin/docker-for-ai-fastapi:0.1
```

The output contains one `sha256:` content identifier for each filesystem
layer. These values are not filenames or directories, and they differ from the
image ID. This tutorial identifies the two layer-related views without
interpreting their structure.

The next tutorial compares the FastAPI image with `python:3.11-slim`, separates
inherited layers from application layers, and explains how the resulting stack
relates to image size and build caching.

## Troubleshooting and cleanup

- If Docker reports `No such image`, confirm the complete name and tag with
  `docker image ls`, then rebuild the image as shown above.
- If the CLI cannot connect to the Docker daemon, start Docker Desktop or
  Docker Engine and wait until it is ready.
- IDs, sizes, history, and layer identifiers can differ across platforms,
  Docker versions, and rebuilds.
- Inspection is not a vulnerability scan, software bill of materials, or proof
  of image provenance.

The inspection commands create no Docker resources, so there is nothing to
remove. Keep the FastAPI image for the next tutorial.

## References

- [`docker image inspect` command](https://docs.docker.com/reference/cli/docker/image/inspect/)
- [`docker image history` command](https://docs.docker.com/reference/cli/docker/image/history/)
- [Docker command formatting](https://docs.docker.com/engine/cli/formatting/)
