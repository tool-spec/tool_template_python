# tool_template_python

[![Docker Image CI](https://github.com/tool-spec/tool_template_python/actions/workflows/docker-image.yml/badge.svg)](https://github.com/tool-spec/tool_template_python/actions/workflows/docker-image.yml)
[![DOI](https://zenodo.org/badge/558416591.svg)](https://zenodo.org/badge/latestdoi/558416591)

Template repository for building a Python tool that follows the [Tool Specification](https://tool-spec.github.io/tool-specs/) container contract.

## How `gotap` works here

This template ships with [`gotap`](https://github.com/tool-spec/gotap) inside the image. The default container command is:

```Dockerfile
CMD ["gotap", "run", "foobar", "--input-file", "/in/input.json"]
```

At build time, `gotap generate` creates `parameters.py` from `src/tool.yml`. At runtime, `run.py` uses the generated bindings to:

- validate `/in/input.json`
- load typed parameters and data paths
- emit structured run logs

## Required file structure

```text
/
|- in/
|  |- input.json
|- out/
|  |- ...
|- src/
|  |- tool.yml
|  |- run.py
|  |- parameters.py   (generated at build time)
|  |- CITATION.cff
```

- `/in/input.json` contains parameter values and data references
- `/out/` receives generated files plus `gotap` metadata such as `_metadata.json`
- `/src/tool.yml` defines the tool metadata and command
- `/src/run.py` is the tool entrypoint referenced by `tool.yml`

## Build and run

Build the image from the template root:

```bash
docker build -t tbr_python_template .
```

Run the sample tool with the bundled input and output folders:

```bash
docker run --rm -it \
  -v "$(pwd)/in:/in" \
  -v "$(pwd)/out:/out" \
  -e TOOL_RUN=foobar \
  tbr_python_template
```

`TOOL_RUN` is only needed when the image contains more than one tool entry. The primary runtime contract is still `/in/input.json` plus `gotap run`.

## Customize

1. Update `src/tool.yml` to describe your real tool.
2. Add Python or system dependencies in `Dockerfile`.
3. Implement the tool logic in `src/run.py`.
4. Rebuild the image so `gotap generate` refreshes `parameters.py`.

## Generated bindings and logging

The generated `parameters.py` file is not edited by hand. It exposes:

- `get_parameters()`
- `get_data()`
- `get_run_context()`
- `get_logger()`

The starter code uses `get_logger()` to write structured JSON Lines logs to the file chosen by `gotap`.
