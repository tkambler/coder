# Web-Based VS Code

This repo contains custom extensions of the [code-server](https://github.com/cdr/code-server) Docker image, allowing you to run VS Code on a remote server.

## Building

    make build // Build everything
    make build-node // Build the Node image - tkambler/coder-node:latest
    make build-python // Build the Python image - tkambler/coder-python:latest
    make build-go // Build the Go image - tkambler/coder-go:latest
    make push // Push latest builds to Docker hub

## What's Included?

- Based on the image - the latest version of Node, Python, Go, etc...
- [ngrok](https://ngrok.com/) utility
- [git](https://git-scm.com/)

The following VS Code extensions are installed by default:

- Dracula Official
- Duplicate action
- EditorConfig for VSCode
- ESLint
- Git History
- GitLens
- GraphQL for VS Code
- Prettier - Code formatter
- YAML

## Running

    ## Coder will be available at: http://localhost:8080
    ## A random password is generated and printed to the console on container startup.
    docker run --rm --name=coder -p "127.0.0.1:8080:8080" tkambler/coder-node:latest
