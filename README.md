# ml-env
Environment for Machine Learning experiments

## Build
To build image, execute: `docker build -t <tag> .` (where `<tag>` can be anything, 
e.g. `ml:latest`). \
To manage additional packages edit `packages.txt` file then rebuild the image.

## Run
To start either jupyter notebook, jupyter lab or shell, run `run_docker_jupyter.py` helper:\
`python run_docker_jupyter.py -t <tag> lab` 

```
usage: run_docker_jupyter.py [-h] [--docker_tag DOCKER_TAG] [--net_host]
                             command

Run docker image.

positional arguments:
  command               Command (notebook | lab | shell)

optional arguments:
  -h, --help            show this help message and exit
  --docker_tag DOCKER_TAG, -t DOCKER_TAG
                        Docker image tag
  --net_host            Whether to use --net=host with docker run (for Linux
                        servers)
```
Then go to http://localhost:4545
