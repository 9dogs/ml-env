# ml-env

[![Docker build](https://img.shields.io/docker/cloud/automated/9dogs/ml-env)](https://hub.docker.com/r/9dogs/ml-env) 
[![License: MIT](https://img.shields.io/github/license/9dogs/ml-env)](https://choosealicense.com/licenses/mit/)

Conda-based environment for machine learning experiments. 

Image has 2 flavors: CPU (~1.7 Gb) and GPU (~2.6 Gb).
Pull `9dogs/ml-env:latest` for GPU-enabled version and `9dogs/ml-env:cpu` for CPU-only version.\
For GPU image to work properly [NVIDIA driver](https://github.com/NVIDIA/nvidia-docker#quickstart) and Docker > 19.03 
must be installed (and you have to have Linux host).

Feel free to adjust `environment.yml` and `additional_packages.txt` to fit your needs.

## Run
To run JupyterLab:
- Windows: `docker run --rm -it -p 4545:4545 -v %cd%:/notebooks -w /notebooks 9dogs/ml-env lab`
- Linux: `docker run --rm -it -p 4545:4545 -v $PWD:/notebooks -w /notebooks 9dogs/ml-env lab`
- Linux with GPU: `docker run --rm -it -p 4545:4545 --gpus all -v $PWD:/notebooks -w /notebooks 9dogs/ml-env lab`

JupyterLab and Jupyter Notebook can be accessed on http://localhost:4545.

Or use `run_docker_jupyter.py` helper:
```
usage: run_docker_jupyter.py [-h] [--docker_tag DOCKER_TAG] [--gpus GPUS]
                             command

Run docker image.

positional arguments:
  command               Command (notebook | lab | shell)

optional arguments:
  -h, --help            show this help message and exit
  --docker_tag DOCKER_TAG, -t DOCKER_TAG
                        Docker image tag
  --gpus GPUS           GPUs to forward to the container (all | 1 | 2 etc.)
```

## Build
To build an image, run: `docker build -t <tag> .` (where `<tag>` can be anything, e.g. `ml:latest`). \
To add packages modify `additional_packages.txt` or `environment.yml` (slower) files then rebuild the image.
