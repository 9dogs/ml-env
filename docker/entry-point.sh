#!/bin/bash -e

case $1 in
  shell )
    /bin/bash
    ;;
  jupyter )
    /opt/conda/bin/jupyter notebook --ip=0.0.0.0 --no-browser --port=4545 --allow-root
    ;;
  lab )
    /opt/conda/bin/jupyter lab --ip=0.0.0.0 --no-browser --port=4545 --allow-root
    ;;
  * )
    echo "Unknown command $1, starting shell"
    /bin/bash
    ;;
esac
