# Tutorial companion code

Each directory contains the public code associated with one Docker 101
tutorial. Narrative drafts, editorial material, and unpublished visual assets
remain in the private authoring repository.

- [Write Your First Dockerfile for a FastAPI
  Application](03-fastapi-dockerfile/) — FastAPI application and introductory
  Dockerfile
- [How to Build a Docker Image from a
  Dockerfile](04-build-fastapi-image/) — builds, tags, and confirms the FastAPI
  image created from the preceding tutorial's Dockerfile
- [How to Push a Docker Image to Docker
  Hub](05-publish-docker-hub/) — signs in to Docker Hub, pushes the tagged
  FastAPI image, and verifies the published repository
- [How to Run a Docker Container from an
  Image](06-run-fastapi-container/) — creates a named FastAPI container,
  publishes its API port to the local machine, verifies the response, and
  cleans up the container
