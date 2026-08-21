# Write Your First Dockerfile for a FastAPI Application

This directory contains the companion code for the tutorial **Write Your First
Dockerfile for a FastAPI Application**.

## Files

- `main.py` — a small FastAPI service that listens on port `8080`
- `requirements.txt` — pinned FastAPI and Uvicorn dependencies
- `Dockerfile` — the image definition introduced in the tutorial
- `build-image.sh` — builds and tags the image from this directory

The tutorial focuses on translating the application's requirements into the
Dockerfile. The build and run workflow is introduced in the following lesson.

## Build the image

With Docker running, execute:

```bash
./build-image.sh
```

The default image reference is `docker-for-ai-fastapi:0.1`. To use a different
name or tag, pass it as the first argument:

```bash
./build-image.sh my-fastapi-app:dev
```

## License

This tutorial is licensed under a [Creative Commons
Attribution-NonCommercial-ShareAlike 4.0
International](https://creativecommons.org/licenses/by-nc-sa/4.0/) License.
