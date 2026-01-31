# blueprints

🫐 Quickstart blueprints for my personal projects.

## Overview

This repository contains project templates (blueprints) to quickly bootstrap new projects with consistent tooling and workflows. All blueprints use [`just`](https://github.com/casey/just) as a command runner with centralized management - each blueprint includes a `just refresh` recipe to fetch the latest version from this repository, eliminating duplication and simplifying multi-project maintenance.

You can use this repository directly for your projects, or fork it and adapt it to your preferences!

## Prerequisites

- [just](https://github.com/casey/just) - command runner (required for all blueprints)

## Quick Start

To apply a blueprint to an existing project folder:

```bash
just apply --blueprint=python --project-folder=/path/to/your/project
```

This will copy all blueprint files into your project directory. You'll be prompted to confirm before proceeding, as this will override any file in that directory.

## Available Blueprints

### Python

> Additional prerequisites: [uv](https://github.com/astral-sh/uv)

A modern Python project template built around `uv` for fast, reliable dependency management. The blueprint includes a comprehensive `justfile` with recipes for development workflows (linting, formatting, testing), build automation, and streamlined releases to PyPI—both manual and automatic through GitHub releases.

```toml
∮ just
Available recipes:
    [build]
    build        # Build the project
    clean        # Remove build artifacts and temporary files

    [dev]
    check        # Run all quality checks
    format       # Format the codebase
    lint         # Lint the codebase
    test         # Run tests
    venv         # Sync and activate the virtual environment (.venv)

    [maintenance]
    lock         # Update uv.lock dependencies
    refresh      # Update this justfile from the blueprint repository
    scan         # Scan for security vulnerabilities

    [release]
    bump level   # Bump the version in pyproject.toml
    publish test # Publish to PyPI (requires authentication)
    release      # Create a GitHub release (which will trigger a PyPi release)
```

The template includes a pre-configured `pyproject.toml` with sensible defaults for the development tools.

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details. 
