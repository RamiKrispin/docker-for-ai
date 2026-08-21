# Repository instructions

## Publication boundary

- This is the supporting repository for the Docker 101 series in The AIOps
  Newsletter.
- Add only reviewed, publication-ready code examples, tests, required public
  documentation, and final assets needed to run the examples.
- Do not add newsletter drafts, release drafts, editorial notes, visual design
  plans, project plans, QA reports, private research, or unpublished assets.
- Promotion from the private `docker-for-ai-authoring` repository is manual and
  allowlisted; never mirror the repositories.

## Implementation conventions

- Keep each tutorial's companion code under `tutorials/##-short-slug/`, using
  its two-digit publication order followed by two to four descriptive words.
- Refer to tutorials in reader-facing documentation by their full published
  titles, not internal development identifiers.
- Make examples runnable from their own directories with documented commands.
- Pin dependencies used by an article and keep Docker build contexts minimal.
- Never commit secrets, credentials, model weights, private data, or
  machine-local artifacts.
- Link released examples to their published AIOps tutorial.

## Public QA

- Validate Python syntax and dependency files for every relevant change.
- Build and run container examples before marking them publication-ready.
- Verify commands and links without access to the private authoring repository.
- Review the exact public file set before each promotion.

## License

- Apply CC BY-NC-SA 4.0 to tutorial artifacts unless the user explicitly
  requests a different license.
- Include the standard license notice in public tutorial pages and notebooks.
