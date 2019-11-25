# ml-env

[![Docker build](https://img.shields.io/docker/cloud/automated/9dogs/ml-env)](https://hub.docker.com/r/9dogs/ml-env) 
[![License: MIT](https://img.shields.io/github/license/9dogs/ml-env)](https://choosealicense.com/licenses/mit/)

Environment for Machine Learning experiments.

## Run
To run JupyterLab:
- Windows: `docker run --rm -it -p 4545:4545 -v %cd%:/notebooks -w /notebooks 9dogs/ml-env lab`
- Linux: `docker run --rm -it -p 4545:4545 -v $PWD:/notebooks -w /notebooks 9dogs/ml-env lab`

JupyterLab and Jupyter Notebook can be accessed on http://localhost:4545.

Or use `run_docker_jupyter.py` helper:
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

## Build
To build an image, run: `docker build -t <tag> .` (where `<tag>` can be anything, e.g. `ml:latest`). \
To add packages modify `environment.yml` file then rebuild the image.
