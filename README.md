# ml-env

[![Docker build](https://img.shields.io/docker/cloud/automated/9dogs/ml-env)](https://hub.docker.com/r/9dogs/ml-env) 
[![License: MIT](https://img.shields.io/github/license/9dogs/ml-env)](https://choosealicense.com/licenses/mit/)

Environment for Machine Learning experiments.

## Build
To build an image, run: `docker build -t <tag> .` (where `<tag>` can be anything, e.g. `ml:latest`). \
To add packages modify `environment.yml` file then rebuild the image.

## Run
To start either jupyter notebook, jupyter lab or shell, run `run_docker_jupyter.py` helper:\
`python run_docker_jupyter.py -t <tag> lab` (or `notebook`, `shell`).

```
usage: run_docker_jupyter.py [-h] [--docker_tag DOCKER_TAG] command

Run docker image.

positional arguments:
  command               Command (notebook | lab | shell)

optional arguments:
  -h, --help            show this help message and exit
  --docker_tag DOCKER_TAG, -t DOCKER_TAG
                        Docker image tag
```
Jupyterlab and Jupyter Notebook can be accessed on http://localhost:4545.
