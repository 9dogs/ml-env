FROM continuumio/miniconda3

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install system packages
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        apt-utils \
        dialog \
        build-essential \
        vim \
        curl \
        unzip \
        git \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

# Add conda channels
RUN /opt/conda/bin/conda config --prepend channels conda-forge \
    && /opt/conda/bin/conda config --prepend channels pytorch

# Install packages to <base> conda environment
COPY environment.yml /tmp/conda-tmp/
RUN /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml \
    && rm -rf /tmp/conda-tmp

# Configure Jupyter
RUN jupyter notebook --allow-root --generate-config -y \
    && echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py \
    && jupyter contrib nbextension install --system \
    && jupyter nbextensions_configurator enable --system \
    && jupyter nbextension enable --py widgetsnbextension \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager \
    && jupyter labextension install @jupyterlab/toc

# Install build dependencies for Vowpal Wabbit
# RUN apt-get --no-install-recommends -y install \
#     build-essential \
#     zlib1g-dev \
#     libboost-dev \
#     libboost-python-dev \
#     libboost-system-dev \
#     libboost-program-options-dev \
#     libboost-thread-dev \
#     libboost-test-dev \
#     automake \
#     cmake \
# && rm -rf /var/lib/apt/lists/*

# Install JDK (for Vowpal Wabbit)
# RUN apt-get -y install openjdk-8-jdk
# ENV CPLUS_INCLUDE_PATH=/usr/lib/jvm/java-8-openjdk-amd64/include/linux:/usr/lib/jvm/java-1.8.0-openjdk-amd64/include

# WORKDIR /build
# Build Vowpal Wabbit
# RUN git clone https://github.com/JohnLangford/vowpal_wabbit.git && \
#    cd vowpal_wabbit && \
#    cmake . && \
#    make -j $(nproc) && \
#    make install
# Vowpal Wabbit Python wrapper
# RUN rm vowpal_wabbit/CMakeCache.txt && \
#    cd vowpal_wabbit/python && \
#    python3 setup.py install

# Build the latest XGBoost
# RUN git clone --recursive https://github.com/dmlc/xgboost && \
#    cd xgboost && \
#    make -j4
# XGBoost Python wrapper
# RUN cd xgboost/python-package && \
#    python3 setup.py install

# Build the latest LightGBM
# RUN git clone --recursive --depth 1 https://github.com/Microsoft/LightGBM && \
#    cd LightGBM && \
#    mkdir build && \
#    cd build && \
#    cmake .. && \
#    make -j $(nproc)
# LightGBM Python wrapper
# RUN cd LightGBM/python-package && \
#    python3 setup.py install

# Clean builds
# WORKDIR /
# RUN rm -rf /build

# Install Facebook Prophet
# RUN pip install --upgrade pystan cython
# RUN pip install --upgrade fbprophet

# Copy notebook configuration and entry-point files
COPY docker/notebook.json /root/.jupyter/nbconfig/notebook.json
COPY docker/entry-point.sh /entry-point.sh
RUN mkdir -p /home/user && \
    chmod a+x /entry-point.sh

WORKDIR /home/user
EXPOSE 4545

ENTRYPOINT ["/entry-point.sh"]
CMD ["shell"]
